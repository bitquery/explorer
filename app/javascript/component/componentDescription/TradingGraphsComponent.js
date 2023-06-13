export default class TradingGraphsComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
    this.chart = null; 
    console.log(this.container)
  }
  
  
  
  async onData(data, sub) {
    console.log(data)
  new TradingView.widget({
  container: this.container,
  locale: 'en',
  library_path: '/assets/charting_library/',
  datafeed: new Datafeeds.UDFCompatibleDatafeed("https://demo-feed-data.tradingview.com"),
  // datafeed: new Datafeeds.UDFCompatibleDatafeed('http://localhost:3000/datafeed', 1000),
  symbol: 'AAPL',
  interval: '1D',
  fullscreen: true,
  debug: true
  });

  
  }
}

