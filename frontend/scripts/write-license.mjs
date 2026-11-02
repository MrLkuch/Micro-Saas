import { writeFileSync } from 'node:fs';

// La clé PrimeNG reste hors du dépôt : elle vient de .env ou des variables de la CI.
const key = process.env.PRIMENG_LICENSE_KEY ?? '';

writeFileSync(
  new URL('../src/app/core/primeng-license.generated.ts', import.meta.url),
  `export const PRIMENG_LICENSE = ${JSON.stringify(key)};\n`,
);
