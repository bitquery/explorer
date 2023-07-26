export default class TradingGraphsComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.historyDataSource = historyDataSource
		this.subscriptionDataSource = subscriptionDataSource
		this.container = element;
		this.lastBar = null
		this.config = this.configuration();
		this.lastData = null;
		this.widget = null;
		this.wrapper = document.createElement('div');
		this.interval = '15'
		this.onHistoryCallback = undefined
		this.periodParams = undefined
		this.minuteIntervals = {
			'1D': 24 * 60,
			'2D': 2 * 24 * 60,
			'3D': 3 * 24 * 60,
			'W': 7 * 24 * 60,
			'3W': 3 * 7 * 24 * 60,
			'M': 30 * 24 * 60,
			'6M': 6 * 30 * 24 * 60
		}
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
			symbol: this.config.symbol,
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
					this.onHistoryCallback = onHistoryCallback
					this.periodParams = periodParams
					this.historyDataSource.setCallback( this.onHistoryData.bind(this) )
					const till = new Date().toISOString().slice(0, 10);
					const tillDate = new Date(till);
					const minutesInterval = this.getIntervalInMinutes(resolution)
					const from = new Date(tillDate.getFullYear(), tillDate.getMonth() - Math.floor(minutesInterval / 5), tillDate.getDate() - (minutesInterval == 1 ? 5 : minutesInterval == 5 ? 0 : 0)).toISOString().slice(0, 10)
					const deltaVariables = {
						from, till,
						interval: `${minutesInterval}`,
						limit: '9990'
					}
					this.historyDataSource.changeVariables( deltaVariables )
				},
				subscribeBars: (symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) => {
					/* this.subscription && this.subscribeOnStream(
						symbolInfo,
						resolution,
						onRealtimeCallback,
						subscriberUID,
						onResetCacheNeededCallback
					); */
				},
				unsubscribeBars: subscriberUID => {
					// this.subscription && this.unsubscribeFromStream(subscriberUID)
				},
			}
		});
	}

	onHistoryData(data) {
		console.log('onHistory this - ', this, data)
		const compatibleData = this.composeBars(data, this.periodParams);
		this.lastBar = compatibleData.at(-1)
		compatibleData.length > 0 ? this.onHistoryCallback(compatibleData, { noData: false }) : this.onHistoryCallback([], { noData: true });
	}

	init() {
		if (this.widget === null) {
			this.wrapper.style.height = '600px';
			this.container.appendChild(this.wrapper);
			this.initWidget();
		}
	}

	getIntervalInMinutes(resolution) {
		return isNaN(+resolution) ? this.minuteIntervals[resolution] : resolution
	}

	async getQueryParams(queryID) {
		const response = await fetch(`${window.bitqueryAPI}/getquery/${queryID}`)
		const { endpoint_url, variables, query, name } = await response.json()
		return {
			variables: JSON.parse(variables),
			query,
			endpoint_url,
			name
		}
	}

	getNextBar(lastBar, newBar) {
		let bar
		if (newBar.time > lastBar.time) {
			//create new bar
			bar = {
				time: newBar.time,
				open: lastBar.close,
				high: newBar.high,
				low: newBar.close,
				close: newBar.close,
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

	composeBars(data, periodParams) {
		const tradeBlock = this.config.topElement(data).sort((a, b) => new Date(a.Block.Time).getTime() - new Date(b.Block.Time).getTime());
		const resultData = []
		for (let i = 0; i < tradeBlock.length; i++) {
			const time = new Date(tradeBlock[i].Block.Time).getTime()
			if (periodParams && ((time / 1000) < periodParams.from || (time / 1000) >= periodParams.to)) {
				continue;
			} else {
				const previousClose = i > 0 ? tradeBlock[i - 1].Trade.close : tradeBlock[i].Trade.open;
				resultData.push({
					time,
					low: tradeBlock[i].Trade.low,
					high: tradeBlock[i].Trade.high,
					open: previousClose,
					close: tradeBlock[i].Trade.close,
					volume: parseFloat(tradeBlock[i].volume)
				})
			}
		}
		return resultData;
	}

	/* async subscribeOnStream(symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) {
		console.log('[subscribeBars]: Method call with subscriberUID:', subscriberUID);
		if (!this.subscribers[subscriberUID]) {
			const minutesInterval = this.getIntervalInMinutes(resolution)
			if (!this.streamingPayload) {
				if (!this.query) {	//comes from explorer with subscriptionID
					const { endpoint_url, variables, query } = await this.getQueryParams(this.config.subscriptionID)
					this.streamingPayload = {
						query, 
						endpoint_url,
						variables: { ...variables, ...this.variables }
					}
				} else {	//comes from IDE with payload
					this.streamingPayload = {
						query: this.query,
						endpoint_url: this.endpointURL,
						variables: { ...this.variables }
					}
				}
			}
			this.streamingPayload.variables.interval = `${minutesInterval}`
			const { endpoint_url, query, variables } = this.streamingPayload
			const currentUrl = endpoint_url.replace(/^http/, 'ws');
			const client = createClient({ url: currentUrl });
			const cleanup = client.subscribe({ query, variables }, {
				next: ({ data }) => {
					const newBar = this.composeBars(data)[0]
					const bar = this.getNextBar(this.lastBar, newBar)
					this.lastBar = { ...bar }
					onRealtimeCallback(bar)
				},
				error: error => {
					console.log(error)
				},
				complete: () => console.log('complete')
			});
			this.subscribers[subscriberUID] = cleanup
		}
	}

	unsubscribeFromStream(subscriberUID) {
		console.log('[unsubscribeBars]: Method call with subscriberUID:', subscriberUID);
		if (this.subscribers[subscriberUID]) {
			this.subscribers[subscriberUID]()
			delete this.subscribers[subscriberUID]
		}
	} */
}
