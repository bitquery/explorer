import { 
	getBaseClass,
	getAPIButton,
	getQueryParams,
	createWidgetFrame,
	SubscriptionDataSource,
	HistoryDataSource
} from "./helper";

export default async function renderComponent(component, selector, queryID, explorerVariables = {}, prepopulateQueryID) {
	document.querySelector(selector).textContent = '';
	const widgetFrame = createWidgetFrame(selector);
	try {
		//get subscription query parameters, setup widget frame
		const subscriptionQueryParams = await getQueryParams(queryID)
		const { endpoint_url, query, variables: rawVariables } = subscriptionQueryParams
		widgetFrame.onloadmetadata(subscriptionQueryParams);
		const compElement = widgetFrame.frame;
		
		//setup subscription datasource
		const variables = { ...rawVariables, ...explorerVariables };
		const subscriptionPayload = { query, variables, endpoint_url }
		const subscriptionDataSource = new SubscriptionDataSource( subscriptionPayload, widgetFrame.onerror )

		//setup history datasource
		const historyQueryParams = await getQueryParams(prepopulateQueryID)
		const historyPayload = {
			variables,
			query: historyQueryParams.query,
			endpoint_url: historyQueryParams.endpoint_url
		}
		const historyDataSource = new HistoryDataSource(historyPayload, widgetFrame)

		//create component instance and initialize
		const componentObject = new component(compElement, historyDataSource, subscriptionDataSource);
		componentObject.init()

		//compose code widget code for IDE
		const data = getBaseClass(component, componentObject.config);
		data.unshift({ [WidgetConfig.name]: serialize(WidgetConfig) });
		
		//setup buttons
		widgetFrame.getStreamingAPIButton.onclick = getAPIButton(data, variables, queryID)
		widgetFrame.getHistoryAPIButton.onclick = getAPIButton(data, variables, prepopulateQueryID)
		widgetFrame.button2.onclick = getNewLimitForShowMoreButton
	} catch (error) {
		console.log(error)
		widgetFrame.onerror(error);
	}
}
