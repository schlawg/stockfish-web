declare module 'stockfish-web' {
  interface StockfishWeb {
    postMessage(uci: string): void;
    addMessageListener: (data: string) => void;
    setNnueBuffer(data: Uint8Array): void;
    getRecommendedNnue(): string;
    errorHandler: (msg: string) => void;
  }
  export default StockfishWeb;
}
