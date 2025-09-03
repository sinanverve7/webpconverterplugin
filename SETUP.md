# WebpconverterPlugin

Convert **JPEG images** from Camera/Gallery to **WebP format (iOS only)** using [SDWebImage](https://github.com/SDWebImage/SDWebImage) + [SDWebImageWebPCoder](https://github.com/SDWebImage/SDWebImageWebPCoder).

---

 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios

Sync with Capacitor befor running the app:

```bash
npx cap sync ios
```

## 🔧 Capacitor 6 Registration (iOS only)

Capacitor 6 **does not auto-register custom plugins** — you must register them manually.

### 1. Import your plugin in `ViewController.swift`

📄 `ios/App/App/MyViewController.swift`

```swift
import UIKit
import Webpconverterplugin
import Capacitor

class MyViewController: CAPBridgeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override open func capacitorDidLoad() {  
        bridge?.registerPluginInstance(WebpconverterPlugin())
    }
}

```



```swift

## 🖥 JavaScript Binding

📄 `src/definitions.ts`

```ts
export interface WebpconverterPlugin {
  convertToWebp(options: ConvertToWebpOptions): Promise<ConvertToWebpResult>;
  deleteTempFile(options: DeleteFileOptions): Promise<{ deleted: boolean }>;
  clearAllTempWebps(): Promise<{ cleared: boolean }>;
}
export interface ConvertToWebpOptions {
  input: string; // fileUri
  quality?: number;
}

export interface ConvertToWebpResult {
  path: string;
}

export interface DeleteFileOptions {
  path: string;
}
```
📄 `src/index.ts`
```ts
import { registerPlugin } from '@capacitor/core';

import type { WebpconverterPlugin } from './definitions';

const Webpconverter = registerPlugin<WebpconverterPlugin>('Webpconverter', {
  web: () => import('./web').then(m => new m.WebpconverterWeb()),
});

export * from './definitions';
export { Webpconverter };

```
📄 `src/web.ts`
```ts
import { WebPlugin } from '@capacitor/core';

import type {
  ConvertToWebpOptions,
  ConvertToWebpResult,
  DeleteFileOptions,
  WebpconverterPlugin,
} from './definitions';

export class WebpconverterWeb extends WebPlugin implements WebpconverterPlugin {
  async convertToWebp(
    options: ConvertToWebpOptions,
  ): Promise<ConvertToWebpResult> {
    {
      console.log(options);

      throw this.unimplemented('Not implemented on web.');
    }
  }
  async deleteTempFile(
    options: DeleteFileOptions,
  ): Promise<{ deleted: boolean }> {
    console.log(options);

    throw this.unimplemented('Not implemented on web.');
  }
  async clearAllTempWebps(): Promise<{ cleared: boolean }> {
    throw this.unimplemented('Not implemented on web.');
  }
}

```
## 🖥 SWIFT Binding

📄 `webpconverterplugin/ios/Sources/webpconverterPlugin/WebpconverterPlugin.sift`

```swift
import Foundation
import Capacitor
import UIKit
import SDWebImage
import SDWebImageWebPCoder

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
/**
 * On creating new custom plugins
 * capacitor command might generate multiple files inside Soucers folder but you need to edit file names accordingly
 * this is following pattern of https://github.com/capacitor-community/facebook-login plugin and codes from chatgpt so check mentioned plugins folder implementation incase you want to add more features on your custom plugin
 * 
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

        guard let input = call.getString("input") else {
            call.reject("Missing input fileUri")
            return
        }

        let quality = call.getInt("quality") ?? 80
        let cleanedPath = input.replacingOccurrences(of: "file://", with: "")
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
            call.resolve(["path": outputURL.absoluteString])
        } catch {
            call.reject("Failed to write WebP file: \(error.localizedDescription)")
        }
    }

    @objc func deleteTempFile(_ call: CAPPluginCall) {
        guard let path = call.getString("path") else {
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

```

---

## 🚀 Usage Example

```ts
import { Webpconverter } from 'webpconverter';

async function run() {
  const fileUri = 'file:///var/mobile/.../photo.jpg';

  // Convert to WebP
  const result = await Webpconverter.convertToWebp({
    fileUri,
    quality: 80, // optional
  });

  console.log('WebP file stored at:', result.webpFileUri);

  // Delete one file
  await Webpconverter.deleteTempFile({ fileUri: result.webpFileUri });

  // Or clear all temp files ( donot use above method created this one for testing purpose)
  await Webpconverter.clearAllTempWebps();
}
```

---

## 📖 API

### convertToWebp(...)

```typescript
convertToWebp(options: ConvertToWebpOptions) => Promise<ConvertToWebpResult>
```

| Param         | Type                                                                  |
| ------------- | --------------------------------------------------------------------- |
| **`options`** | <code><a href="#converttowebpoptions">ConvertToWebpOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#converttowebpresult">ConvertToWebpResult</a>&gt;</code>

---

### deleteTempFile(...)

```typescript
deleteTempFile(options: DeleteFileOptions) => Promise<{ deleted: boolean; }>
```

| Param         | Type                                                            |
| ------------- | --------------------------------------------------------------- |
| **`options`** | <code><a href="#deletefileoptions">DeleteFileOptions</a></code> |

**Returns:** <code>Promise&lt;{ deleted: boolean; }&gt;</code>

---

### clearAllTempWebps()

```typescript
clearAllTempWebps() => Promise<{ cleared: boolean; }>
```

**Returns:** <code>Promise&lt;{ cleared: boolean; }&gt;</code>

---

### Interfaces

#### ConvertToWebpResult

| Prop              | Type                | Description                                       |
| ----------------- | ------------------- | ------------------------------------------------- |
| **`webpFileUri`** | <code>string</code> | Converted image fileUri (stored in temp folder). |

#### ConvertToWebpOptions

| Prop          | Type                | Description                                    |
| ------------- | ------------------- | ---------------------------------------------- |
| **`fileUri`** | <code>string</code> | File URI of JPEG image to convert to WebP.     |
| **`quality`** | <code>number</code> | Quality of resulting WebP image (default 100). |

#### DeleteFileOptions

| Prop          | Type                | Description                                                   |
| ------------- | ------------------- | ------------------------------------------------------------- |
| **`fileUri`** | <code>string</code> | Temporary WebP file URI (stored in temp folder) to remove.    |

---

## 🛠 Troubleshooting

- **Error: "Webpconverter plugin is not implemented on ios"**
  - Ensure you imported your plugin in `ViewController.swift`
  - Ensure you registered with `bridge?.registerPluginInstance(WebpconverterPlugin())`
  - Ensure your `ViewController` is the root VC in `AppDelegate.swift`
  - Run `npx cap sync ios` after every plugin code change

- **Build fails: `Cannot find 'WebpconverterPlugin' in scope`**
  - Check `import WebpconverterPlugin` at the top of `ViewController.swift`
  - Make sure `WebpconverterPlugin.swift` is listed in **Xcode → Build Phases → Compile Sources**

- **WebP file not created**
  - Ensure `SDWebImage` + `SDWebImageWebPCoder` are included in your `.podspec`
  - Run `pod install` in `ios/` after editing `podspec`

---

## 📖 Recap of Steps

1. Generate plugin:  
   ```bash
   npx @capacitor/cli plugin:generate
   ```
2. Add `WebpconverterPlugin.swift` with SDWebImage logic
3. Update `Webpconverter.podspec` with dependencies
4. Add `plugin.xml` referencing Swift source
5. Register plugin manually in `ViewController.swift`
6. Set `ViewController` as root in `AppDelegate.swift`
7. Sync + build:  
   ```bash
   npx cap sync ios && npx cap open ios
   ```
8. Use in JS via `registerPlugin('Webpconverter')`

---

## 📜 License

MIT
