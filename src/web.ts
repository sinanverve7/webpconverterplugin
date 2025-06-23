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
