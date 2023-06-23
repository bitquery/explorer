export default class TradingGraphsComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
    this.lastBar = null; 
    this.lastData = null; 
    this.allData = [];
    this.widget = null;
  }
  initWidget(symbolName) {
    const configurationData = {
            supports_marks: false,
      supports_timescale_marks: false,
      supports_time: true,
      supported_resolutions: ['1', '5', '15', '30', '60',"D", "2D", "3D", "W", "3W", "M", "6M"]
    }
      this.widget = new TradingView.widget({
        container: this.container,
        locale: 'en',
        library_path: '/assets/charting_library/',
        width:700,
        height: 500,
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
                has_daily:true,
                // has_ticks: true,
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
              const arr = this.allData;
            let bars = [];
            console.log('arr',arr)
            arr.forEach(bar => {
              if (bar.time/ 1000 >= periodParams.from && bar.time/ 1000 < periodParams.to) {
                bars = [...bars,{
                  time: bar.time,
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
            this.lastBar = setInterval(() => {
              const latestData = this.allData; 
              if (JSON.stringify(this.lastData) !== JSON.stringify(latestData)) {
                this.lastData = latestData;
                onRealtimeCallback(this.lastData[this.lastData.length - 1]); 
              }
            }, 60000); 
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
      interval: this.config.interval, //add variable
      fullscreen: false,
      debug: true
    });
  }

  async onData(data, sub) {
        // console.log(data);
    const symbolName = data.symbol;
   if (this.widget === null) {
      this.initWidget(symbolName); 
    }
    this.allData = this.getBitqueryData(data); 
  }

  getBitqueryData(data){
    const tradeBlock = this.config.topElement(data);
    const resultData = tradeBlock.map((item, index) => {
      const previousClose = index > 0 ? tradeBlock[index - 1].Trade.close : item.Trade.open;
      return {
        time: new Date(item.Block.Time).getTime(),
        low: item.Trade.low,
        high: item.Trade.high,
        open: item.Trade.open,
        // open: previousClose,
        close: item.Trade.close,
        volume: parseFloat(item.volume),
      }
    });

    console.log('resultData',resultData)
    
    return resultData;
  }


}
