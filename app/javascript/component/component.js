import {
    getBaseClass,
    getAPIButton,
    getQueryParams,
    createWidgetFrame,
    HistoryDataSource,
    increaseLimitButton,
    SubscriptionDataSource
} from "./helper";

export default async function renderComponent(component, selector, historyQueryID, explorerVariables = {}, subscriptionQueryID) {
    document.querySelector(selector).textContent = '';
    const widgetFrame = createWidgetFrame(selector, subscriptionQueryID, historyQueryID);
    let variables, compElement, subscriptionDataSource, historyDataSource, queryTitle
    //get subscription query parameters, setup widget frame
    if (subscriptionQueryID) {
        const subscriptionQueryParams = await getQueryParams(subscriptionQueryID)
        const {endpoint_url, query, variables: rawVariables} = subscriptionQueryParams
        widgetFrame.onloadmetadata(subscriptionQueryParams);
        compElement = widgetFrame.frame;

        //setup subscription datasource
        variables = {...rawVariables, ...explorerVariables};
        const subscriptionPayload = {query, variables, endpoint_url}
        subscriptionDataSource = new SubscriptionDataSource(subscriptionPayload, widgetFrame)
    }
    if (historyQueryID) {
        //setup history datasource
        const historyQueryParams = await getQueryParams(historyQueryID)
        if (!compElement) {
            widgetFrame.onloadmetadata(historyQueryParams, queryTitle);
            compElement = widgetFrame.frame;
        }
        variables = variables || {...historyQueryParams.variables, ...explorerVariables}
        const historyPayload = {
            variables,
            query: historyQueryParams.query,
            endpoint_url: historyQueryParams.endpoint_url
        }
        historyDataSource = new HistoryDataSource(historyPayload, widgetFrame)
    }

    //create component instance and initialize
    const componentObject = new component(compElement, historyDataSource, subscriptionDataSource);
    componentObject.init(widgetFrame)
    widgetFrame.onchangetitle(componentObject.config.title)

    //compose code widget code for IDE
    const data = getBaseClass(component, componentObject.config);
    data.unshift({[WidgetConfig.name]: serialize(WidgetConfig)});

    //setup buttons
    widgetFrame.getStreamingAPIButton.onclick = getAPIButton(data, variables, subscriptionQueryID)
    widgetFrame.getHistoryAPIButton.onclick = getAPIButton(data, variables, historyQueryID)
    widgetFrame.showMoreButton.onclick = increaseLimitButton(historyDataSource)
}
