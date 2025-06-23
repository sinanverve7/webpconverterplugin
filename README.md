# webpconverterplugin

convert jpeg image from Camera/Gallery to webp format (iOS only)

## Install

```bash
npm install webpconverterplugin
npx cap sync
```

## API

<docgen-index>

* [`convertToWebp(...)`](#converttowebp)
* [`deleteTempFile(...)`](#deletetempfile)
* [`clearAllTempWebps()`](#clearalltempwebps)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### convertToWebp(...)

```typescript
convertToWebp(options: ConvertToWebpOptions) => Promise<ConvertToWebpResult>
```

| Param         | Type                                                                  |
| ------------- | --------------------------------------------------------------------- |
| **`options`** | <code><a href="#converttowebpoptions">ConvertToWebpOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#converttowebpresult">ConvertToWebpResult</a>&gt;</code>

--------------------


### deleteTempFile(...)

```typescript
deleteTempFile(options: DeleteFileOptions) => Promise<{ deleted: boolean; }>
```

| Param         | Type                                                            |
| ------------- | --------------------------------------------------------------- |
| **`options`** | <code><a href="#deletefileoptions">DeleteFileOptions</a></code> |

**Returns:** <code>Promise&lt;{ deleted: boolean; }&gt;</code>

--------------------


### clearAllTempWebps()

```typescript
clearAllTempWebps() => Promise<{ cleared: boolean; }>
```

**Returns:** <code>Promise&lt;{ cleared: boolean; }&gt;</code>

--------------------


### Interfaces


#### ConvertToWebpResult

| Prop              | Type                | Description                                       |
| ----------------- | ------------------- | ------------------------------------------------- |
| **`webpFileUri`** | <code>string</code> | converted image fileUri ( stored in temp folder). |


#### ConvertToWebpOptions

| Prop          | Type                | Description                                   |
| ------------- | ------------------- | --------------------------------------------- |
| **`fileUri`** | <code>string</code> | fileUri of jpeg image to convert to webp.     |
| **`quality`** | <code>number</code> | quality fo resulting webp image default 100%. |


#### DeleteFileOptions

| Prop          | Type                | Description                                                                  |
| ------------- | ------------------- | ---------------------------------------------------------------------------- |
| **`fileUri`** | <code>string</code> | temporary webp image fileUri ( stored in temp folder) for removing manually. |

</docgen-api>
