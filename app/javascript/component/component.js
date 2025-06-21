import {
    getBaseClass,
    getAPIButton,
    streamControl,
    mempoolStreamControl,
    switchDataset,
    getQueryParams,
    createWidgetFrame,
    HistoryDataSource,
    increaseLimitButton,
    SubscriptionDataSource, getAPIMempoolButton
} from "./helper";

export default async function renderComponent(token,use_eap, components, historyQueryID, explorerVariables = {}, subscriptionQueryID) {
    let variables, subscriptionDataSource, historyDataSource, subscriptionQueryParams, historyQueryParams
    const endpoint_url = use_eap.toString() === 'true' ? 'https://streaming.bitquery.io/eap' : 'https://streaming.bitquery.io/graphql';
    
    try {
        if (subscriptionQueryID) {
            subscriptionQueryParams = await getQueryParams(subscriptionQueryID)
            const { query, variables: rawVariables} = subscriptionQueryParams
            variables = {...rawVariables, ...explorerVariables};
            const subscriptionPayload = {query, variables, endpoint_url}
            subscriptionDataSource = new SubscriptionDataSource(token, subscriptionPayload)
        }
    } catch (error) {
        console.error(`Failed to load subscription query ${subscriptionQueryID}:`, error);
    }
    
    try {
        if (historyQueryID) {
            historyQueryParams = await getQueryParams(historyQueryID)
            variables = variables || {...historyQueryParams.variables, ...explorerVariables}
            const historyPayload = {
                variables,
                query: historyQueryParams.query,
                endpoint_url
            }
            historyDataSource = new HistoryDataSource(token, historyPayload)
        }
    } catch (error) {
        console.error(`Failed to load history query ${historyQueryID}:`, error);
    }

    components.forEach(async component => {
        const ComponentConstructor = component[0]
        const componentSelector = component[1]
        const componentElement = document.querySelector(componentSelector)
        
        if (!componentElement) {
            console.error(`Component selector ${componentSelector} not found`);
            return;
        }
        
        componentElement.textContent = ''
        
        if (!subscriptionDataSource && !historyDataSource) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'alert alert-danger m-3';
            errorDiv.innerHTML = `
                <h4 class="alert-heading">Failed to load data</h4>
                <p>Unable to load query configuration. Please check:</p>
                <ul>
                    <li>The query IDs are correct</li>
                    <li>The API server is accessible</li>
                    <li>Your network connection is stable</li>
                </ul>
                <p class="mb-0">Query IDs: ${historyQueryID || 'none'} / ${subscriptionQueryID || 'none'}</p>
            `;
            componentElement.appendChild(errorDiv);
            return;
        }
        
        const widgetFrame = createWidgetFrame(componentSelector, subscriptionQueryID, historyQueryID, subscriptionDataSource)
        if (subscriptionDataSource) {
            widgetFrame.onloadmetadata(subscriptionQueryParams)
            subscriptionDataSource.setWidgetFrame(widgetFrame)
        }
        if (historyDataSource) {
            widgetFrame.onloadmetadata(historyQueryParams)
            historyDataSource.setWidgetFrame(widgetFrame)
        }
        const componentObject = new ComponentConstructor(widgetFrame.frame, historyDataSource, subscriptionDataSource)
        componentObject.init(widgetFrame)

        const data = getBaseClass(ComponentConstructor, componentObject.config);
        data.unshift({['WidgetConfig']: serialize(WidgetConfig)});
        widgetFrame.mempoolControlButton.onclick = mempoolStreamControl(subscriptionDataSource, widgetFrame)
        widgetFrame.switchButton.onclick = switchDataset(widgetFrame, historyDataSource, subscriptionDataSource)
        widgetFrame.streamControlButton.onclick = streamControl(subscriptionDataSource, widgetFrame)
        widgetFrame.getHistoryAPIButton.onclick = getAPIButton(widgetFrame, data, variables, historyQueryID, subscriptionQueryID, subscriptionDataSource)
    })

    historyDataSource && await historyDataSource.changeVariables()
}
