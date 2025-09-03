# WebpconverterPlugin

Convert **JPEG images** from Camera/Gallery to **WebP format (iOS only)** using [SDWebImage](https://github.com/SDWebImage/SDWebImage) + [SDWebImageWebPCoder](https://github.com/SDWebImage/SDWebImageWebPCoder).

---

Sync with Capacitor befor running the app:

```bash
npx cap sync ios
```

---

## 🔧 Capacitor 6 Registration (iOS only)

Capacitor 6 **does not auto-register custom plugins** — you must register them manually.

### 1. Import your plugin in `ViewController.swift`

📄 `ios/App/App/ViewController.swift`

```swift
import UIKit
import Capacitor
import WebpconverterPlugin   // 👈 import your plugin module

class ViewController: CAPBridgeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func capacitorDidLoad() {
        bridge?.registerPluginInstance(WebpconverterPlugin())
    }
}
```

### 2. Ensure `ViewController` is the Root VC

📄 `ios/App/App/AppDelegate.swift`

```swift
import UIKit
import Capacitor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  internal func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    let vc = ViewController()        // 👈 your custom ViewController
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = vc
    window?.makeKeyAndVisible()
    return true
  }
}
```

---

## 🖥 JavaScript Binding

📄 `src/definitions.ts`

```ts
import { registerPlugin } from '@capacitor/core';

export interface ConvertToWebpOptions {
  fileUri: string;
  quality?: number; // default 100
}

export interface ConvertToWebpResult {
  webpFileUri: string;
}

export interface DeleteFileOptions {
  fileUri: string;
}

export interface WebpconverterPlugin {
  convertToWebp(options: ConvertToWebpOptions): Promise<ConvertToWebpResult>;
  deleteTempFile(options: DeleteFileOptions): Promise<{ deleted: boolean }>;
  clearAllTempWebps(): Promise<{ cleared: boolean }>;
}

export const Webpconverter = registerPlugin<WebpconverterPlugin>('Webpconverter');
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

  // Or clear all temp files
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
