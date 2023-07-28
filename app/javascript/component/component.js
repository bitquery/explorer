import { 
	getBaseClass,
	getAPIButton,
	getQueryParams,
	createWidgetFrame,
	HistoryDataSource,
	increaseLimitButton,
	SubscriptionDataSource
} from "./helper";

export default async function renderComponent(component, selector, subscriptionQueryID, explorerVariables = {}, historyQueryID) {
	document.querySelector(selector).textContent = '';
	const widgetFrame = createWidgetFrame(selector, subscriptionQueryID, historyQueryID);
	try {
		let variables, compElement, subscriptionDataSource, historyDataSource
		//get subscription query parameters, setup widget frame
		if (subscriptionQueryID) {
			const subscriptionQueryParams = await getQueryParams(subscriptionQueryID)
			const { endpoint_url, query, variables: rawVariables } = subscriptionQueryParams
			widgetFrame.onloadmetadata(subscriptionQueryParams);
			compElement = widgetFrame.frame;
			
			//setup subscription datasource
			variables = { ...rawVariables, ...explorerVariables };
			const subscriptionPayload = { query, variables, endpoint_url }
			subscriptionDataSource = new SubscriptionDataSource( subscriptionPayload, widgetFrame.onerror )
		}
		if (historyQueryID) {
			//setup history datasource
			const historyQueryParams = await getQueryParams(historyQueryID)
			if (!compElement) {
				widgetFrame.onloadmetadata(historyQueryParams);
				compElement = widgetFrame.frame;
			}
			const historyPayload = {
				variables: variables || { ...historyQueryParams.variables, ...explorerVariables },
				query: historyQueryParams.query,
				endpoint_url: historyQueryParams.endpoint_url
			}
			historyDataSource = new HistoryDataSource(historyPayload, widgetFrame)
		}

		//create component instance and initialize
		const componentObject = new component(compElement, historyDataSource, subscriptionDataSource);
		componentObject.init()

		//compose code widget code for IDE
		const data = getBaseClass(component, componentObject.config);
		data.unshift({ [WidgetConfig.name]: serialize(WidgetConfig) });
		
		//setup buttons
		widgetFrame.getStreamingAPIButton.onclick = getAPIButton(data, variables, subscriptionQueryID)
		widgetFrame.getHistoryAPIButton.onclick = getAPIButton(data, variables, historyQueryID)
		// widgetFrame.showMoreButton.onclick = increaseLimitButton(componentObject.clearData(), historyDataSource)
	} catch (error) {
		console.log(error)
		widgetFrame.onerror(error);
	}
}
