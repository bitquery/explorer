export default class TradingGraphsComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.symbol = null;
    this.variables = variables;
    this.lastBar = null;
    this.lastData = null;
    this.allData = [];
    this.widget = null;
    this.minuteBars = [];
  }
  initWidget(symbolName) {
    const configurationData = {
      supports_marks: false,
      supports_timescale_marks: false,
      supports_time: true,
      supported_resolutions: ['15'],
      // supported_resolutions: ['1', '5', '15', '30', '60', 'D', '2D', '3D', 'W', '3W', 'M', '6M'],
    };
    this.widget = new TradingView.widget({
      container: this.container,
      locale: 'en',
      library_path: '/assets/charting_library/',
      width: 800,
      height: 500,
      datafeed: {
        onReady: callback => {
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
              has_daily: true,
              has_ticks: true,
              minmov: 1,
              pricescale: 10000,
              has_empty_bars: true,
              data_status: 'streaming',
            };
            onSymbolResolvedCallback(symbolInfo);
          }, 0);
        },
        getBars: async (symbolInfo, resolution, periodParams, onHistoryCallback, onErrorCallback, firstDataRequest) => {
          console.log('[getBars]: Method call', symbolInfo);
          console.log('periodParams', periodParams);
          const arr = this.allData;
          let bars = [];
          console.log('arr', arr);
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
          console.log('bars', bars);
          bars.length > 0 ? onHistoryCallback(bars, {noData: false}) : onHistoryCallback([], {noData: true});
        },
        subscribeBars: (symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) => {
          console.log('[subscribeBars]: Method call with subscriberUID:', subscriberUID);

          this.lastBar = setInterval(() => {
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
          console.log('subscriberUID', subscriberUID);
          console.log('[unsubscribeBars]: Method call with subscriberUID:', subscriberUID);
          if (this.lastBar !== null) {
            clearInterval(this.lastBar);
            this.lastBar = null;
            this.lastData = null;
          }
        },
      },
      symbol: this.symbol,
      interval: this.config.interval, //add variable
      time_frames: [
        { text: "1y", resolution: "15", description: "1 Year",},
        {text: '8m', resolution: '15', description: '8 Month'},
        {text: '3d', resolution: '15', description: '3 Days'},
        {text: '1d', resolution: '15', description: '1 day'},
      ],
      header_widget_buttons_mode: 'compact',
      disabled_features: ['go_to_date','main_series_scale_menu','control_bar','scales_date_format','header_symbol_search','header_compare', 'compare_symbol_search_spread_operators'],
      time_scale: {
        min_bar_spacing: 20,
      },
      fullscreen: false,
      debug: true,
    });
  }

  onData(data, sub) {
    const symbolName = data.symbol;
    this.symbol = `${this.config.token1(data)} / ${this.config.token2(data)}`;
    if (this.widget === null) {
      this.initWidget(symbolName);
    }
    const newData = this.getBitqueryData(data);

    if (newData.length > 1) {
      this.allData = newData;
    } else if (newData.length === 1) {
      const newBar = newData[0];
      if (this.allData.length === 0 || newBar.time >= this.allData[this.allData.length - 1].time + this.config.interval * 60 * 1000) {
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
//   changeInterval(newInterval) {
//   this.config.interval = newInterval;

//   let newAllData = [];

//   for(let i = 0; i < this.allData.length; i += this.config.interval) {
//     let intervalData = [];
//     for(let j = 0; j < this.config.interval && (i+j) < this.allData.length; j++) {
//       intervalData.push(this.allData[i+j]);
//     }

//     let bar = this.create15MinuteBar(intervalData);
    
//     newAllData.push(bar);
//   }

//   this.allData = newAllData;

//   if(this.widget) {
//       this.initWidget(symbolName);

//   }
// }


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
      open: item.Trade.open,
      // open: previousClose,
      close: item.Trade.close,
      volume: parseFloat(item.volume),
    };
  });

  console.log('resultData', resultData);

  return resultData;
}

}
