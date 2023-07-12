import { 
	runQuery,
	runWidget,
	getBaseClass,
	getQueryParams,
	getStreamingAPI,
	createWidgetFrame,
	renderQueryInComponent
} from "./helper";

export default async function renderComponent(component, selector, queryID, explorerVariables = {}, prepopulateQueryID) {
	document.querySelector(selector).textContent = '';
	const widgetFrame = createWidgetFrame(selector);
	try {
		const queryParams = await getQueryParams(queryID)
		const { endpoint_url, query, variables: rawVariables } = queryParams
		widgetFrame.onloadmetadata(queryParams);
		const compElement = widgetFrame.frame;
		const variables = { ...rawVariables, ...explorerVariables };

		async function getNewDataForQuery(interval, from, to) {
			widgetFrame.button2.style.display = 'none'
			const payload = { endpoint_url, query, variables: { ...variables, limit: 9990, interval, from, to }, prepopulateQueryID }
			const data = await renderQueryInComponent(payload)
			return data
		}
		async function getNewLimitForShowMoreButton() {
			widgetFrame.onquerystarted();
			variables.limit += 10
			componentObject.clearData();
			const payload = { endpoint_url, query, variables, prepopulateQueryID }
			runWidget(payload, componentObject, api_key, widgetFrame.onerror)
		}
		if (Object.getPrototypeOf(component) === BootstrapTableComponent || Object.getPrototypeOf(component) === BootstrapCardComponent) {
			widgetFrame.button2.parentNode.style.justifyContent = 'space-between';
			widgetFrame.button2.style.display = 'block'
			if (query.startsWith('subscription')) {
				widgetFrame.button2.style.display = 'none'
				widgetFrame.button2.parentNode.style.justifyContent = 'end';

			}
		}

		const componentObject = new component(compElement, variables, getNewDataForQuery);

		const data = getBaseClass(component, componentObject.config);
		data.unshift({ [WidgetConfig.name]: serialize(WidgetConfig) });
		
		widgetFrame.button.onclick = getStreamingAPI(data, variables, queryID)
		widgetFrame.button2.onclick = getNewLimitForShowMoreButton
		widgetFrame.onquerystarted();

		const payload = { endpoint_url, query, variables, prepopulateQueryID }
		await runWidget(payload, componentObject, widgetFrame.onerror)

		widgetFrame.onqueryend();
	} catch (error) {
		widgetFrame.onerror(error);
	}
}
