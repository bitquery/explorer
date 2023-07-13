export default class TradingGraphsComponent {
	constructor(element, { query, variables, endpoint_url }) {
		this.container = element;
		this.variables = variables
		this.historyQuery = null
		this.historyVariables = null
		this.query = query
		this.endpointURL = endpoint_url
		this.subscribers = {}
		this.lastBar = null
		this.config = this.configuration();
		this.lastData = null;
		this.allData = [];
		this.widget = null;
		this.minuteBars = [];
		this.wrapper = document.createElement('div');
		this.interval = this.config.interval(this.variables);
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

					const till = new Date().toISOString().slice(0, 10);
					const tillDate = new Date(till);
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
					const from = new Date(tillDate.getFullYear(), tillDate.getMonth() - Math.floor( minutesResolution / 5 ), tillDate.getDate() - (minutesResolution == 1 ? 5 : minutesResolution == 5 ? 0 : 0)).toISOString().slice(0, 10)
					let data
					if (this.query) {
						const payload = {
							endpoint_url: this.endpointURL,
							query: this.query,
							variables: {
								...this.variables,
								from, to,
								interval: `${minutesResolution}`,
								limit: '9990'
							}
						}
						data = await this.runQuery(payload)
					} else {
						if (!this.historyQuery) {
							const { endpoint_url, variables, query } = await this.getQueryParams(this.config.historyID)
							this.endpointURL = endpoint_url
							this.historyVariables = variables
							this.historyQuery = query
						}
						const variables = {
							...this.historyVariables,
							...this.variables,
							from, till,
							interval: `${minutesResolution}`,
							limit: '9990'
						}
						const payload = {
							query: this.historyQuery,
							variables,
							endpoint_url: this.endpointURL }
						data = await this.runQuery(payload)
					}
					let bars = [];
					const compatibleData = this.composeBars(data);
					compatibleData.forEach(bar => {
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
					bars.length > 0 ? onHistoryCallback(bars, { noData: false }) : onHistoryCallback([], { noData: true });
				},
				subscribeBars: (symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) => {
					this.subscribeOnStream(
						symbolInfo,
						resolution,
						onRealtimeCallback,
						subscriberUID,
						onResetCacheNeededCallback,
					);
				},
				unsubscribeBars: subscriberUID => {
					console.log('[unsubscribeBars]: Method call with subscriberUID:', subscriberUID);
        			this.unsubscribeFromStream(subscriberUID)
				},
			}
		});
	}

	onData() {
		if (this.widget === null) {
			this.wrapper.style.height = '600px';
			this.container.appendChild(this.wrapper);
			this.initWidget();
		}
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

	async runQuery({ endpoint_url, query, variables }) {
		const response = await fetch(endpoint_url, {
			method: 'POST',
			headers: {
				Accept: 'application/json',
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ query, variables }),
			credentials: 'same-origin',
		});
		if (response.status !== 200) {
			throw new Error(response.error);
		}
		const { data } = await response.json();
		if (data.errors) {
			throw new Error(data.errors[0].message);
		}
		return data
	}

	getNextBar(lastBar, newBar) {
		let bar
		if (newBar.time > lastBar.time) {
			//create new bar
			bar = {
				time: newBar.time,
				open: lastBar.close,
				high: lastBar.close,
				low: lastBar.close,
				close: lastBar.close,
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

	async subscribeOnStream(symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) {
		console.log('[subscribeBars]: Method call with subscriberUID:', subscriberUID);
		if (!this.subscribers[subscriberUID]) {
			const { endpoint_url, variables: defaultVariables, query } = await this.getQueryParams(this.config.subscriptionID)
			const variables = {
				...defaultVariables,
				...this.variables,
				interval: `${resolution}`
			}
			const currentUrl = endpoint_url.replace(/^http/, 'ws');
			const client = createClient({ url: currentUrl });
			const cleanup = client.subscribe({ query, variables }, {
				next: ({ data }) => {
					const newBar = this.composeBars(data)[0]
					const bar = this.getNextBar(this.lastBar, newBar)
					this.lastBar = {...bar}
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
		if (this.subscribers[subscriberUID]) {
			this.subscribers[subscriberUID]()
			delete this.subscribers[subscriberUID]
		}
	}
}
