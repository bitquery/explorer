export default class TradingGraphsComponent {
	constructor(element, variables, getNewDataForQuery) {
		this.container = element;
		this.variables = variables;
		this.getNewDataForQuery = getNewDataForQuery;
		this.config = this.configuration();
		this.symbol = null;
		this.lastData = null;
		this.allData = [];
		this.widget = null;
		this.minuteBars = [];
		this.wrapper = document.createElement('div');
		this.interval = this.config.interval(this.variables);
		this.onRealtimeCallback = null;
	}
	initWidget() {
		const configurationData = {
			supports_marks: true,
			supports_timescale_marks: true,
			supports_time: true,
			supported_resolutions: ['1', '5', '15', '30', '60', '1D', '2D', '3D', '1W', '3W', '1M', '6M'],
		};
		this.widget = new TradingView.widget({
			container: this.wrapper,
			locale: 'en',
			symbol: this.symbol,
			interval: this.interval,
			disabled_features: ['header_symbol_search', 'header_compare'],
			fullscreen: false,
			autosize: true,
			debug: false,
			library_path: '/charting_library/',
			time_frames: [
				{ text: '1D', resolution: '15', description: '1 Day' },
				{ text: '5D', resolution: '60', description: '5 Days' },
				{ text: '1M', resolution: '60', description: '1 Month' },
				{ text: '3M', resolution: '60', description: '3 Months' },
				{ text: '6M', resolution: '1W', description: '6 Months' },
				{ text: '1Y', resolution: '1M', description: '1 Year' },
				{ text: '3Y', resolution: '6M', description: '3 Years' },
			],
			datafeed: {
				onReady: callback => {
					setTimeout(() => callback(configurationData));
				},
				resolveSymbol: (symbolName, onSymbolResolvedCallback, onResolveErrorCallback, extension) => {
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
							pricescale: 100000,
							has_empty_bars: true,
							data_status: 'streaming',
						};
						onSymbolResolvedCallback(symbolInfo);
					}, 0);
				},
				getBars: async (symbolInfo, resolution, periodParams, onHistoryCallback, onErrorCallback, firstDataRequest) => {
					this.interval = resolution;

					const till = new Date().toISOString().slice(0, 10);
					const tillDate = new Date(till);
					const from = new Date(tillDate.getFullYear(), tillDate.getMonth() - Math.floor( resolution / 5 ), tillDate.getDate() - (resolution == 1 ? 5 : resolution == 5 ? 30 : 0)).toISOString().slice(0, 10)
					const minuteIntervals = {
						'1D': 24*60,
						'2D': 2*24*60,
						'3D': 3*24*60,
						'W': 7*24*60,
						'3W': 3*7*24*60,
						'M': 30*24*60,
						'6M': 6*30*24*60
					}
					const minutesResolution = isNaN(+resolution) ? minuteIntervals[resolution] : resolution
					let newData = await this.getNewDataForQuery(minutesResolution, from, till);
					let bars = [];
					newData = this.composeBars(newData);
					if (newData.length > 1) {
						this.allData = newData;
					}
					this.allData.forEach(bar => {
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
					console.log('last bar from getBras - ', bars.at(-1))
					bars.length > 0 ? onHistoryCallback(bars, { noData: false }) : onHistoryCallback([], { noData: true });
				},
				subscribeBars: (symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) => {
					console.log('subscribe - ', subscriberUID)
					this.onRealtimeCallback = onRealtimeCallback
					/* subscribeOnStream(
						symbolInfo,
						resolution,
						onRealtimeCallback,
						subscriberUID,
						onResetCacheNeededCallback,
						lastBarsCache.get(symbolInfo.full_name)
					); */
				},
				unsubscribeBars: subscriberUID => {
					console.log('unsubscribe - ', subscriberUID)
					clearInterval(this.interval);
				},
			}
		});
	}

	onData(data, sub) {
		this.symbol = `${this.config.token1(data)} / ${this.config.token2(data)}`;
		if (this.widget === null) {
			this.wrapper.style.height = '600px';
			this.container.appendChild(this.wrapper);
			this.initWidget();
		} else {
			const lastBar = this.composeBars(data)
			console.log({lastBar})
			const bar = this.getNextBar([this.allData.at(-1), lastBar[0]])
			console.log({bar})
			this.onRealtimeCallback(bar)
		}
		/* const newData = this.getBitqueryData(data);
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
		} */
	}

	getNextBar(lastTwoBars) {
		console.log({lastTwoBars})
		const time = lastTwoBars.at(-1).time;
		const open = time > lastTwoBars[0].time ? lastTwoBars.at(-1).open : lastTwoBars[0].open;
		const close = lastTwoBars.at(-1).close;
		const high = Math.max(...lastTwoBars.map(bar => bar.high));//
		const low = Math.min(...lastTwoBars.map(bar => bar.low));//
		const volume = time > lastTwoBars[0].time ? lastTwoBars.at(-1).volume : lastTwoBars.reduce((sum, bar) => sum + bar.volume, 0);//

		return { time, open, high, low, close, volume };
	}

	composeBars(data) {
		const tradeBlock = this.config.topElement(data).sort((a, b) => new Date(a.Block.Time).getTime() - new Date(b.Block.Time).getTime());

		const resultData = tradeBlock.map((item, index) => {
			const previousClose = index > 0 ? tradeBlock[index - 1].Trade.close : item.Trade.open;
			return {
				time: new Date(item.Block.Time).getTime(),
				low: item.Trade.low,
				high: item.Trade.high,
				open: previousClose,
				close: item.Trade.close,
				volume: parseFloat(item.volume),
			};
		});
		return resultData;
	}
}
