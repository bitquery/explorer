export default class TradingGraphsComponent {
	constructor(element, variables, getNewDataForQuery) {
		this.container = element;
		this.variables = variables;
		this.getNewDataForQuery = getNewDataForQuery;
		this.lastBar = null
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
					this.lastBar = {...bars.at(-1)}
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
			const newBar = this.composeBars(data)[0]
			const bar = this.getNextBar(this.lastBar, newBar)
			console.log({bar})
			this.lastBar = {...bar}
			this.onRealtimeCallback(bar)
		}
	}

	getNextBar(lastBar, newBar) {
		let bar
		if (newBar.time > lastBar.time) {
			//create new bar
			bar = {
				time: newBar.time,
				open: newBar.open,
				high: newBar.open,
				low: newBar.open,
				close: newBar.open,
				volume: newBar.volume
			}
		} else {
			//update bar
			bar = {
				...lastBar,
				high: Math.max(lastBar.high, newBar.high),
				low: Math.min(lastBar.low, newBar.low),
				close: newBar.close,
				volume: lastBar.volume + newBar.volume
			}
		}
		return bar
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
