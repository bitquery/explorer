export default class TradingGraphsComponent {
  constructor(element, variables,getNewDataForQuery) {
    this.container = element;
    this.config = this.configuration();
    this.symbol = null;
    this.variables = variables;
    this.lastBar = null;
    this.lastData = null;
    this.allData = [];
    this.widget = null;
    this.minuteBars = [];
    this.wrapper = document.createElement('div');
    this.getNewDataForQuery = getNewDataForQuery;
    this.interval = this.config.interval

  }
  initWidget(symbolName) {
    const configurationData = {
      supports_marks: true,
      supports_timescale_marks: true,
      supports_time: true,
      supported_resolutions: ['1', '5', '15', '30', '60', '1D', '2D', '3D', '1W', '3W', '1M', '6M'],
      // supported_resolutions: [ '15'],
    //   intraday_multipliers: ['1', '5', '15', '30', '60', '1D', '2D', '3D', '1W', '3W', '1M', '6M'],
    };
    this.widget = new TradingView.widget({
      container:  this.wrapper,
      locale: 'en',
      library_path: '/charting_library/',
      time_frames: [
        { text: "1D", resolution: "15", description: "1 Day" },
        { text: "5D", resolution: "60", description: "5 Days" },
        { text: "1M", resolution: "60", description: "1 Month" },
        { text: "3M", resolution: "60", description: "3 Months" },
        { text: "6M", resolution: "1W", description: "6 Months" },
        { text: "1Y", resolution: "1M", description: "1 Year" },
        { text: "3Y", resolution: "6M", description: "3 Years" },
      ],
      datafeed: {
        onReady: callback => {
          setTimeout(() => callback(configurationData));
        },
        resolveSymbol: (symbolName, onSymbolResolvedCallback, onResolveErrorCallback, extension) => {
          const splitSymbol = symbolName.split(/[:/]/);
          setTimeout(() => {
            const symbolInfo = {
              name: symbolName,
              description: '',
              session: '24x7',
              timezone: 'Etc/UTC',
              has_intraday: true,
              has_seconds: true,
              has_daily: true,
              has_ticks: true,
              minmov: 1,
              pricescale: 1000,
              has_empty_bars: true,
              data_status: 'streaming',
              
            };
            onSymbolResolvedCallback(symbolInfo);
          }, 0);
        },
        getBars: async (symbolInfo, resolution, periodParams, onHistoryCallback, onErrorCallback, firstDataRequest) => {
          // console.log('[getBars]: Method call', symbolInfo);
          // console.log('periodParams', periodParams);
          // console.log('%%%%%%%%% resolution %%%%%%%%', resolution)
          this.interval = resolution
         
            const till = new Date().toISOString().slice(0, 10);
           const tillDate = new Date(till);
         if(resolution === '1'){
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth(), tillDate.getDate() - 5); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolution, from, till)
            // console.log('from',from, 'till',till)
          }
          if(resolution === '5'){
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth(), tillDate.getDate() - 30); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolution, from, till)
          }
          if(resolution === '15'){
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 3, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolution, from, till)
          }
          if(resolution === '30'){
             const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 6, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolution, from, till)
          }
          if(resolution === '60'){
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 13, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolution, from, till)
          }
          if(resolution === '1D'){
            const resolutionToMinutes = 1440
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 285, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolutionToMinutes, from, till)
          }
          if(resolution === '2D'){
           const  resolutionToMinutes = 2880
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 160, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolutionToMinutes, from, till)
          }
          if(resolution === '3D'){
            const resolutionToMinutes = 4320
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 320, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolutionToMinutes, from, till)
          }
          if(resolution === 'W'){
            const resolutionToMinutes = 10080
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 640, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolutionToMinutes, from, till)
          }
          if(resolution === '3W'){
            const resolutionToMinutes = 30240
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 1280, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolutionToMinutes, from, till)
          }
          if(resolution === 'M'){
            const resolutionToMinutes = 43829
            const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 2360, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolutionToMinutes, from, till)
          }
          if(resolution === '6M'){
            const resolutionToMinutes = 262974
           const fromDate = new Date(tillDate.getFullYear(), tillDate.getMonth() - 4720, tillDate.getDate()); 
            const from = fromDate.toISOString().slice(0, 10);
            const newData = await this.getNewDataForQuery(resolutionToMinutes, from, till)
          }
          const arr = this.allData;
            // console.log('  ===================newData', arr);
            // console.log('  ===================variables', variables);

          let bars = [];
          arr.forEach(bar => {
            if (bar.time / 1000 >= periodParams.from && bar.time / 1000 < periodParams.to) {
              bars = [
                ...bars,
                {
                  time: bar.time,
                  close: bar.close,
                  open: bar.open,
                  high: bar.high,
                  low: bar.low,
                  volume: bar.volume,
                },
              ];
            }
          });
          bars.length > 0 ? onHistoryCallback(bars, {noData: false}) : onHistoryCallback([], {noData: true});
        },
        subscribeBars: (symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) => {
          setInterval(() => {
            const latestData = this.allData[this.allData.length - 1];
            if (JSON.stringify(this.lastData) !== JSON.stringify(latestData)) {
              this.lastData = latestData;
              const currentCandle = {
                time: latestData.time,
                open: latestData.open,
                high: latestData.high,
                low: latestData.low,
                close: latestData.close,
                volume: latestData.volume,
              };

              if (this.allData.length > 1 && this.allData[this.allData.length - 2].time === latestData.time) {
                this.allData[this.allData.length - 2] = currentCandle;
              }
              onRealtimeCallback(currentCandle);
            }
          }, 1000);
        },

        unsubscribeBars: subscriberUID => {
          // if (this.lastBar !== null) {
            clearInterval(this.interval);

          //   this.lastBar = null;
          //   this.lastData = null;
          // }
        },
      },
      symbol: this.symbol,
      interval: this.interval, 
      disabled_features: ['header_symbol_search','header_compare'],
      fullscreen: false,
      autosize: true,
      debug: false,
    });
  }

  onData(data, sub) {
    // console.log('this.interval',this.interval)
    const symbolName = data.symbol;
    this.symbol = `${this.config.token1(data)} / ${this.config.token2(data)}`;
    if (this.widget === null) {
      this.wrapper.style.height = '600px'
      this.container.appendChild(this.wrapper) 
      this.initWidget(symbolName);
    }
    const newData = this.getBitqueryData(data);
    if (newData.length > 1) {
      this.allData = newData;
    } else if (newData.length === 1) {
      const newBar = newData[0];
      if (this.allData.length === 0 || newBar.time >= this.allData[this.allData.length - 1].time + this.interval * 60 * 1000) {
        const bar15min = this.create15MinuteBar([newBar]);
        this.allData.push(bar15min);
      } else {
        const currentCandle = this.create15MinuteBar([this.allData[this.allData.length - 1], newBar]);
        this.allData[this.allData.length - 1] = currentCandle;
      }
    }
  }

  create15MinuteBar(oneMinuteBars) {
    const time = oneMinuteBars[0].time;
    const open = oneMinuteBars[0].open;
    const close = oneMinuteBars[oneMinuteBars.length - 1].close;
    const high = Math.max(...oneMinuteBars.map(bar => bar.high));
    const low = Math.min(...oneMinuteBars.map(bar => bar.low));
    const volume = oneMinuteBars.reduce((sum, bar) => sum + bar.volume, 0);

    return {time, open, high, low, close, volume};
  }

  getBitqueryData(data) {
    let tradeBlock = this.config.topElement(data);
    tradeBlock = tradeBlock.sort((a, b) => {
      return new Date(a.Block.Time).getTime() - new Date(b.Block.Time).getTime();
    });

    const resultData = tradeBlock.map((item, index) => {
      const previousClose = index > 0 ? tradeBlock[index - 1].Trade.close : item.Trade.open;
      return {
        time: new Date(item.Block.Time).getTime(),
        low: item.Trade.low,
        high: item.Trade.high,
        // open: item.Trade.open,
        open: previousClose,
        close: item.Trade.close,
        volume: parseFloat(item.volume),
      };
    });
// console.log('####### resultData ########',resultData)
    return resultData;
  }

}
