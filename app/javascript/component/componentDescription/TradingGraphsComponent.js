export default class TradingGraphsComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
    this.lastBar = null; 
    this.lastData = null; 
  }
  
  async onData(data, sub) {
    console.log(data);
    const configurationData = {
      supports_marks: false,
      supports_timescale_marks: false,
      supports_time: true,
      supported_resolutions: ['1', '5', '15', '30', '60',"D", "2D", "3D", "W", "3W", "M", "6M"]
    }
    const symbolName =data.symbol
    new TradingView.widget({
      container: this.container,
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
              has_intraday: true,
              has_seconds: true,
              minmov: 1,
              pricescale: 10000,
              has_empty_bars: true,
              data_status: 'streaming',
            }
            onSymbolResolvedCallback(symbolInfo);
          }, 0);
        },
        getBars: async (symbolInfo, resolution, periodParams, onHistoryCallback, onErrorCallback, firstDataRequest) => {
          console.log('[getBars]: Method call', symbolInfo);
          console.log('periodParams',periodParams)
          const arr = this.getBitqueryData(data).sort((a, b) => a.time - b.time);
          let bars = [];
          console.log('arr',arr)
          arr.forEach(bar => {
            if (bar.time >= periodParams.from && bar.time < periodParams.to) {
              console.log('from >>>>>>bar.time <<<<<to ', bar.time)
              bars = [...bars,{
                time: bar.time * 1000,
                close: bar.close,
                open: bar.open,
                high: bar.high,
                low: bar.low,
                volume: bar.volume
              }];
            }
          });
          console.log('bars', bars);
          (bars.length > 0) ? onHistoryCallback(bars, { noData: false }): onHistoryCallback([], { noData: true });
        },

        subscribeBars: (symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) => {
          console.log('[subscribeBars]: Method call with subscriberUID:', subscriberUID);
          this.lastBar = setInterval(async () => {
            const latestData = this.getBitqueryData(this.data).sort((a, b) => a.time - b.time);;
            console.log('latestData', latestData);
            console.log('this.lastData', this.lastData);
            if ( latestData.length > 0 && JSON.stringify(this.lastData) !== JSON.stringify(latestData)) {
              this.lastData = latestData;
              onRealtimeCallback(latestData);
            }
          },120000); 
        },
        unsubscribeBars: (subscriberUID) => {
          console.log('subscriberUID',subscriberUID)
          console.log('[unsubscribeBars]: Method call with subscriberUID:', subscriberUID);
          if (this.lastBar !== null) {
            clearInterval(this.lastBar);
            this.lastBar = null;
            this.lastData = null;
          }
        },
      },
      symbol: this.config.symbol,
      interval: '15', //add variable
      fullscreen: true,
      debug: false
    });
  }
  getBitqueryData(data) {
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
