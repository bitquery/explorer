// export default class TradingGraphsComponent {
//   constructor(element, variables) {
//     this.container = element;
//     this.config = this.configuration();
//     this.variables = variables;
//     this.chart = null; 
//     console.log(this.container)
//   }
  
//   createOrUpdateChart(symbol) {
//     if (!this.chart) {
//       this.chart = new TradingView.widget(
//       {
//         "container_id": "tradingview_512af",
// "autosize": true,
//   "symbol": "NASDAQ:AAPL",
//   "interval": "D",
//   "timezone": "Etc/UTC",
//   "theme": "light",
//   "style": "1",
//   "locale": "ru",
//   "toolbar_bg": "#f1f3f6",
//   "enable_publishing": true,
//   "withdateranges": true,
//   "hide_side_toolbar": false,
//   "allow_symbol_change": true,
//   "details": true,
//   "hotlist": true,
//   "calendar": true,
//   "show_popup_button": true,
//   "popup_width": "1000",
//   "popup_height": "650",
//       });
//     } else {
//       this.chart.setSymbol(symbol);
//     }
//   }
  
//   async onData(data, sub) {
//     const symbol = this.config.symbol(data);
//     console.log('symbol', symbol)
    
//     if (document.readyState === "complete" || document.readyState === "loaded" || document.readyState === "interactive") {
//       this.createOrUpdateChart(symbol);
//     } else {
//       document.addEventListener("DOMContentLoaded", () => {
//         this.createOrUpdateChart(symbol);
//       });
//     }
//   }
// }
export default class TradingGraphsComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
    this.chart = LightweightCharts.createChart(this.container, { width: 500, height: 300 });
    this.candleSeries = this.chart.addCandlestickSeries();
  }

  async onData(data, sub) {
    const ohlcData = this.config.ohlcData(data);

    this.candleSeries.setData(ohlcData);
  }
}

