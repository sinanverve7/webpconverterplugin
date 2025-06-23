import Foundation
import Capacitor
import UIKit
import SDWebImage
import SDWebImageWebPCoder

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(WebpconverterPlugin)
public class WebpconverterPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "WebpconverterPlugin"
    public let jsName = "Webpconverter"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "convertToWebp", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "deleteTempFile", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "clearAllTempWebps", returnType: CAPPluginReturnPromise),

    ]

    private var webpCoderInitialized = false

    private func ensureWebPCoderRegistered() {
        if !webpCoderInitialized {
            let webpCoder = SDImageWebPCoder.shared
            SDImageCodersManager.shared.addCoder(webpCoder)
            webpCoderInitialized = true
        }
    }

    @objc func convertToWebp(_ call: CAPPluginCall) {
        ensureWebPCoderRegistered()

        guard let fileUri = call.getString("fileUri") else {
            call.reject("Missing fileUri")
            return
        }

        let quality = call.getInt("quality") ?? 100
        let cleanedPath = fileUri.replacingOccurrences(of: "file://", with: "")
        guard let image = UIImage(contentsOfFile: cleanedPath) else {
            call.reject("Failed to load image at path: \(cleanedPath)")
            return
        }

        guard let webpData = image.sd_imageData(as: .webP, compressionQuality: CGFloat(quality) / 100.0) else {
            call.reject("WebP encoding failed")
            return
        }

        let fileName = "converted_\(Int(Date().timeIntervalSince1970)).webp"
        let tmpDir = NSTemporaryDirectory()
        let outputURL = URL(fileURLWithPath: tmpDir).appendingPathComponent(fileName)

        do {
            try webpData.write(to: outputURL)
            call.resolve(["webpFileUri": outputURL.absoluteString])
        } catch {
            call.reject("Failed to write WebP file: \(error.localizedDescription)")
        }
    }

    @objc func deleteTempFile(_ call: CAPPluginCall) {
        guard let path = call.getString("fileUri") else {
            call.reject("Missing file path")
            return
        }

        let cleanedPath = path.replacingOccurrences(of: "file://", with: "")
        do {
            try FileManager.default.removeItem(atPath: cleanedPath)
            call.resolve(["deleted": true])
        } catch {
            call.reject("Delete failed: \(error.localizedDescription)")
        }
    }

    @objc func clearAllTempWebps(_ call: CAPPluginCall) {
        let tmpDir = NSTemporaryDirectory()
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: tmpDir)
            for file in files where file.hasPrefix("converted_") && file.hasSuffix(".webp") {
                try FileManager.default.removeItem(atPath: tmpDir + file)
            }
            call.resolve(["cleared": true])
        } catch {
            call.reject("Clear failed: \(error.localizedDescription)")
        }
    }
}
