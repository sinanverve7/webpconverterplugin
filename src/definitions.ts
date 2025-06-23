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
