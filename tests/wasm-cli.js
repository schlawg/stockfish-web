import * as readline from 'node:readline';
import * as fs from 'node:fs';

import createStockfish from '../stockfishWeb.js';
const sf = await createStockfish();

let history = [],
  index = 0; // basic history buffer

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  prompt: '',
  terminal: true,
});

rl.on('SIGINT', process.exit);

rl.on('line', line => {
  history.push(line);
  index = history.length;
  if (line.startsWith('setoption name EvalFile value ')) sf.setNnueBuffer(fs.readFileSync(line.slice(30)));
  else if (line === 'exit' || line === 'quit') process.exit();
  else sf.postMessage(line);
});

process.stdin.on('kepress', (_, key) => {
  if (key.name === 'up') {
    if (index < 1) return;
    index--;
    rl.write(null, { ctrl: true, name: 'u' });
    rl.write(history[index]);
  } else if (key.name === 'down') {
    if (index > history.length - 2) return;
    index++;
    rl.write(null, { ctrl: true, name: 'u' });
    rl.write(history[index]);
  }
});

if (process.argv.length > 2) {
  console.log('Loading NNUE file from ' + process.argv[2] + '...');
  sf.setNnueBuffer(fs.readFileSync(process.argv[2]));
}
