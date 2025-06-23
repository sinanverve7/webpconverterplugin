export interface WebpconverterPlugin {
  convertToWebp(options: ConvertToWebpOptions): Promise<ConvertToWebpResult>;
  deleteTempFile(options: DeleteFileOptions): Promise<{ deleted: boolean }>;
  clearAllTempWebps(): Promise<{ cleared: boolean }>;
}

export interface ConvertToWebpOptions {
  /**
   * fileUri of jpeg image to convert to webp.
   */
  fileUri: string;
  /**
   * quality fo resulting webp image default 100%.
   */
  quality?: number;
}

export interface ConvertToWebpResult {
  /**
   * converted image fileUri ( stored in temp folder).
   */
  webpFileUri: string;
}

export interface DeleteFileOptions {
  /**
   * temporary webp image fileUri ( stored in temp folder) for removing manually.
   */
  fileUri: string;
}


// sample usage

// import { Camera, CameraResultType, CameraSource } from "@capacitor/camera";
// import { Webpconverter } from "webpconverterplugin/";

// async function captureAndConvertPhoto(){
//     const image = await Camera.getPhoto({
//         quality: 90, // Adjust the quality of the image
//         resultType: CameraResultType.Uri, // Get a file URI
//         source: CameraSource.Photos, // Open the photo library
//         saveToGallery: false,
//     });
//     const {webpFileUri} = (await Webpconverter.convertToWebp({ input: imageURI, quality: 60 }));
// }
