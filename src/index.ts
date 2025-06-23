import { registerPlugin } from '@capacitor/core';

import type { WebpconverterPlugin } from './definitions';

const Webpconverter = registerPlugin<WebpconverterPlugin>('Webpconverter', {
  web: () => import('./web').then(m => new m.WebpconverterWeb()),
});

export * from './definitions';
export { Webpconverter };
