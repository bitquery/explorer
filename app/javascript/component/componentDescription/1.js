export default class TradingGraphsComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
    this.chart = null; 
    this.data = null;
    this.lastBar = null; 
    this.lastData = null; 
  }
  
  async onData(data, sub) {
    const self = this;
    self.data = data; 
    if (self.chart) {
      self.chart.onResetCacheNeededCallback();
    }

    console.log(data);
    const configurationData = {
      supports_marks: false,
      supports_timescale_marks: false,
      supports_time: true,
      supported_resolutions: ["D", "2D", "3D", "W", "3W", "M", "6M"]
    }
    
    let resolution = 'D';
    const symbolName = this.data.symbol
    new TradingView.widget({
      container: self.container,
      locale: 'en',
      library_path: '/assets/charting_library/',
      datafeed: {
        onReady: (callback) => {  
          console.log('[onReady]: Method call');
          setTimeout(() => callback(configurationData));
        },
        resolveSymbol: (symbolName, onSymbolResolvedCallback, onResolveErrorCallback, extension) => {
          console.log('[resolveSymbol]: Method call', symbolName);
          const splitSymbol = symbolName.split(/[:/]/);
          setTimeout(() => {
            const symbolInfo = {
              name: symbolName,
              description: symbolName,
              session: '24x7',
              timezone: 'Etc/UTC',
              exchange: splitSymbol[0],
              listed_exchange: splitSymbol[0],
              minmov: 1,
              pricescale: 10000,
              data_status: 'streaming',
              supported_resolutions: ['1', '5', '15', '30', '60', '1D', '1W', '1M']
            }
            onSymbolResolvedCallback(symbolInfo);
          }, 0);
        },
        getBars: async (symbolInfo, resolution, periodParams, onHistoryCallback, onErrorCallback, firstDataRequest) => {
          console.log('[getBars]: Method call', symbolInfo);
          console.log('periodParams',periodParams)
          const arr = this.getBitqueryData(self.data).sort((a, b) => a.time - b.time);
          let bars = [];
          arr.forEach(bar => {
            console.log('one bar', bar)
            console.log('periodParams.to', periodParams.to)
            console.log('bar.time', bar.time)
            console.log('periodParams.from', periodParams.from)
            if (bar.time >= periodParams.from && bar.time < periodParams.to) {
              bars.push({
                time: bar.time * 1000,
                low: bar.low,
                high: bar.high,
                open: bar.open,
                close: bar.close,
              });
            }
            console.log('bars', bars);
          });
          if(bars.length > 0) {
            onHistoryCallback(bars, { noData: false });
          } else {
            onHistoryCallback([], { noData: true });

            console.log('No data');
          }
        },

        subscribeBars: (symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) => {
          console.log('[subscribeBars]: Method call with subscriberUID:', subscriberUID);
          self.lastBar = setInterval(async () => {
            const latestData = this.getBitqueryData(self.data);
            console.log('latestData', latestData);
            if (latestData && latestData.length > 0 && JSON.stringify(self.lastData) !== JSON.stringify(latestData)) {
              self.lastData = latestData;
              // onRealtimeCallback(latestData);
            }
          }, 60000); 
        },
        unsubscribeBars: (subscriberUID) => {
          console.log('[unsubscribeBars]: Method call with subscriberUID:', subscriberUID);
          if (self.lastBar !== null) {
            clearInterval(self.lastBar);
            self.lastBar = null;
            self.lastData = null;
          }
        },
      },
      symbol: self.config.symbol,
      interval: '1',
      fullscreen: true,
      debug: false
    });
  }
  getBitqueryData(data) {
//     data.EVM.DEXTradeByTokens.forEach(e => {
//       console.log('bladskoe vremya',new Date(e.Block.Time).getTime(),
// )
//     });
return data.EVM.DEXTradeByTokens.map(item => ({
  time: new Date(item.Block.Time).getTime() / 1000,
  low: item.Trade.low,
  high: item.Trade.high,
  open: item.Trade.open,
  close: item.Trade.close,
  volume: parseFloat(item.volume)
}))

  }

}
