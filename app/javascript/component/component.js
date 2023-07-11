import { runWidget, createWidgetFrame, getBaseClass } from "./helper";

export default async function renderComponent(component, selector, queryId, variables = {}, prepopulateQueryID, getNewDataForQuery, api_key) {
	document.querySelector(selector).textContent = '';
	const widgetFrame = createWidgetFrame(selector);
	let queryMetaData;
	try {
		const response = await fetch(`${window.bitqueryAPI}/getquery/${queryId}`);
		if (response.status === 200) {
			try {
				queryMetaData = await response.json();
			} catch (error) {
				throw new Error('There is no such query with the same url...');
			}
		} else {
			throw new Error(response.message);
		}
		widgetFrame.onloadmetadata(queryMetaData);
		const compElement = widgetFrame.frame;
		const query = queryMetaData.query.trim();
		const queryVariables = {
			...JSON.parse(queryMetaData.variables),
			...variables,
		};

		const getStreamingAPI = () => {
			let createHiddenField = function (name, value) {
				let input = document.createElement('input');
				input.setAttribute('type', 'hidden');
				input.setAttribute('name', name);
				input.setAttribute('value', value);
				return input;
			};
			let form = document.createElement('form');
			form.setAttribute('method', 'post');
			form.setAttribute('action', `${window.bitqueryAPI}/widgetconfig`);
			form.setAttribute('enctype', 'application/json');
			form.setAttribute('target', '_blank');
			form.appendChild(createHiddenField('data', JSON.stringify(data)));
			form.appendChild(createHiddenField('variables', JSON.stringify(queryVariables)));
			form.appendChild(createHiddenField('url', queryId));
			document.body.appendChild(form);
			form.submit();
			document.body.removeChild(form);
		};
		async function getNewDataForQuery(interval) {
			widgetFrame.button2.style.display = 'none'

			const addVariables = {
				interval,
				limit: 9990,
			};
			const queryVariables = {
				...JSON.parse(queryMetaData.variables),
				...variables,
				...addVariables,
			};
			const payload = {
				endpoint_url: queryMetaData.endpoint_url,
				query,
				variables: queryVariables,
				prepopulateQueryID
			}

			runWidget(payload, componentObject, api_key, widgetFrame.onerror)
		}
		async function getNewLimitForShowMoreButton() {
			widgetFrame.onquerystarted();
			queryVariables.limit += 10
			console.log('queryVariables.limit', queryVariables.limit)
			componentObject.clearData();
			const payload = {
				endpoint_url: queryMetaData.endpoint_url,
				query,
				variables: queryVariables,
				prepopulateQueryID
			}
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
		const componentObject = new component(compElement, queryVariables, getNewDataForQuery);

		const data = getBaseClass(component, componentObject.config);
		data.unshift({ [WidgetConfig.name]: serialize(WidgetConfig) });
		
		widgetFrame.button.onclick = getStreamingAPI
		widgetFrame.onquerystarted();
		widgetFrame.button2.onclick = () => getNewLimitForShowMoreButton()

		const payload = {
			endpoint_url: queryMetaData.endpoint_url,
			query,
			variables: queryVariables,
			prepopulateQueryID
		}

		runWidget(payload, componentObject, api_key, widgetFrame.onerror)
		widgetFrame.onqueryend();
	} catch (error) {
		widgetFrame.onerror(error);
	}
}
