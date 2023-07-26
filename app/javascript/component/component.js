import { 
	getData,
	runWidget,
	getBaseClass,
	getAPIButton,
	getQueryParams,
	createWidgetFrame,
	renderQueryInComponent
} from "./helper";

export default async function renderComponent(component, selector, queryID, explorerVariables = {}, prepopulateQueryID) {
	document.querySelector(selector).textContent = '';
	const widgetFrame = createWidgetFrame(selector);
	try {
		const subscriptionQueryParams = await getQueryParams(queryID)
		const { endpoint_url, query, variables: rawVariables } = subscriptionQueryParams
		widgetFrame.onloadmetadata(subscriptionQueryParams);
		const compElement = widgetFrame.frame;
		const variables = { ...rawVariables, ...explorerVariables };
		const subscriptionPayload = { query, variables, endpoint_url }

		function SubscriptionDataSource(payload, onerror) {

			const subscribe = () => {
				const currentUrl = payload.endpoint_url.replace(/^http/, 'ws');
				const client = createClient({ url: currentUrl });

				this.cleanSubscription = client.subscribe({ query: payload.query, variables: payload.variables }, {
					next: this.callback,
					error: error => {
						console.log(error)
						onerror(error);
					},
					complete: () => console.log('complete'),
				});
			} 

			const setCallback = callback => {
				this.callback = callback
				subscribe()
			}

			const changeVariables = async deltaVariables => {
				this.variables = { ...payload.variables, ...deltaVariables }
				this.cleanSubscription()
				subscribe()
			}

			return {
				setCallback,
				changeVariables
			}

		}
		const subscriptionDataSource = new SubscriptionDataSource( subscriptionPayload, widgetFrame.onerror )

		const historyQueryParams = await getQueryParams(prepopulateQueryID)
		const historyPayload = {
			variables,
			query: historyQueryParams.query,
			endpoint_url: historyQueryParams.endpoint_url
		}
		function HistoryDataSource(payload) {

			const setCallback = callback => {
				this.callback = callback
			}

			const changeVariables = async deltaVariables => {
				this.variables = { ...payload.variables, ...deltaVariables }
				this.data = await getData({ ...payload, variables: this.variables })
				this.callback(data)
			}

			return {
				setCallback,
				changeVariables
			}

		}
		const historyDataSource = new HistoryDataSource(historyPayload)

		const componentObject = new component(compElement, historyDataSource, subscriptionDataSource);

		const data = getBaseClass(component, componentObject.config);
		data.unshift({ [WidgetConfig.name]: serialize(WidgetConfig) });
		
		widgetFrame.getStreamingAPIButton.onclick = getAPIButton(data, variables, queryID)
		widgetFrame.getHistoryAPIButton.onclick = getAPIButton(data, variables, prepopulateQueryID)
		widgetFrame.button2.onclick = getNewLimitForShowMoreButton
		widgetFrame.onquerystarted();


		
		
		if (componentObject.constructor.name === 'OHLCbyIntervalsGraph') {
			componentObject.onData(undefined, true)
		} else {
			widgetFrame.getHistoryAPIButton.style.display = 'none'
			await runWidget(payload, componentObject, widgetFrame.onerror)
		}
		widgetFrame.onqueryend();
	} catch (error) {
		widgetFrame.onerror(error);
	}
}
