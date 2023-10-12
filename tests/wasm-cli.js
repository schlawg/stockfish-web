import * as readline from 'node:readline';
import * as fs from 'node:fs';

import createStockfish from '../stockfishWeb.js';
const sf = await createStockfish();

if (process.argv.length > 2) {
  console.log('Loading NNUE file from ' + process.argv[2] + '...');
  sf.setNnueBuffer(fs.readFileSync(process.argv[2]));
}

console.log('Awaiting commands...');
readline
  .createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
  })
  .on('line', line => {
    // To load a NNUE file from within the shell, use "nnue <filename>" (not setoption).
    if (line.startsWith('nnue ')) sf.nnue(fs.readFileSync(line.slice(5)));
    else sf.postMessage(line);
  });
