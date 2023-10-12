const listeners = [];

Module['addMessageListener'] = listener => listeners.push(listener);

Module['print'] = function (data) {
  if (listeners.length === 0) console.log(data);
  else
    setTimeout(function () {
      for (const listener of listeners) listener(data);
    }, 0);
};

Module['printErr'] = function (data) {
  if (Module['errorHandler']) Module['errorHandler'](data);
  else console.error(data);
};

Module['postMessage'] = function (uci) {
  const sz = lengthBytesUTF8(uci) + 1;
  const utf8 = _malloc(sz); // deallocated in src/wasm/glue.cpp
  if (!utf8) throw new Error(`Could not allocate ${sz} bytes`);
  stringToUTF8(uci, utf8, sz);
  _uci(utf8);
};

Module['getRecommendedNnue'] = () => UTF8ToString(_getRecommendedNnue());

Module['setNnueBuffer'] = function (buf /** Uint8Array */) {
  if (buf.byteLength <= 0) throw new Error(`${buf.byteLength} bytes?`);
  const heapBuf = _malloc(buf.byteLength); // deallocated in src/wasm/glue.cpp
  if (!heapBuf) throw new Error(`Could not allocate ${buf.byteLength} bytes`);
  Module['HEAPU8'].set(buf, heapBuf);
  _setNnueBuffer(heapBuf, buf.byteLength);
};
