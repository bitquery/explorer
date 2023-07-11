const isNotEmptyArray = subj => Array.isArray(subj) && subj.length;
const isNotEmptyObject = subj => !Array.isArray(subj) && typeof subj === 'object' && Object.keys(subj).length;

export const getBaseClass = (targetClass, config) => {
	const discoverFunctions = (subj, prop) => {
		if (typeof subj === 'function') {
			if (prop && subj?.name !== prop) {
				if (!data.some(el => Object.keys(el)[0] === subj?.name)) {
					data.unshift({ [subj.name]: serialize(subj) });
				}
			}
			return;
		}
		if (isNotEmptyArray(subj)) {
			for (let el of subj) {
				discoverFunctions(el);
			}
		}
		if (isNotEmptyObject(subj)) {
			for (let prop in subj) {
				discoverFunctions(subj[prop], prop);
			}
		}
	}
	const data = []
	data.push({ [targetClass.name]: serialize(targetClass) });
	if (targetClass instanceof Function) {
		let baseClass = targetClass;
		while (baseClass) {
			const newBaseClass = Object.getPrototypeOf(baseClass);
			if (newBaseClass && newBaseClass !== Object && newBaseClass.name) {
				baseClass = newBaseClass;
				data.unshift({ [baseClass.name]: serialize(baseClass) });
			} else {
				break;
			}
		}
	}
	discoverFunctions(config)
	return data
}

export const runWidget = (payload, widgetInstance, api_key, onerror) => {

	const runQuery = async (payload) => {
		const response = await fetch(payload.endpoint_url, {
			method: 'POST',
			headers: {
				Accept: 'application/json',
				'Content-Type': 'application/json',
				'X-API-KEY': api_key
			},
			body: JSON.stringify({ query: payload.query, variables: payload.variables }),
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
	};

	const renderQueryInComponent = async (payload) => {
		const data = await runQuery(payload);
		widgetInstance.onData(data);
	};

	const prepopulateWidget = async () => {
		if (!payload.prepopulateQueryID) {
			return
		}
		console.log('prepopulate')
		let queryMetaData
		const response = await fetch(`${window.bitqueryAPI}/getquery/${payload.prepopulateQueryID}`);
		if (response.status === 200) {
			queryMetaData = await response.json();
		} else {
			throw new Error(response.error);
		}
		const currentPayload = {
			endpoint_url: payload.endpoint_url,
			query: queryMetaData.query,
			variables: {
				...JSON.parse(queryMetaData.variables),
				...payload.variables,
			}
		}
		renderQueryInComponent(currentPayload);
	};

	const subscribeWidget = async () => {
		const currentUrl = payload.endpoint_url.replace(/^http/, 'ws');
		const client = createClient({ url: currentUrl });

		client.subscribe({ query: payload.query, variables: payload.variables }, {
			next: ({ data }) => {
				const sub = 'subscription';
				widgetInstance.onData(data, sub);
			},
			error: error => {
				onerror(error);
			},
			complete: () => console.log('complete'),
		});
	};

	if (payload.query.startsWith('subscription')) {
		prepopulateWidget()
		subscribeWidget()
	} else {
		renderQueryInComponent(payload)
	}
}

export const createWidgetFrame = selector => {
	const componentContainer = document.querySelector(selector);
	const widgetHeader = document.createElement('div');
	const row = document.createElement('div');
	const col8 = document.createElement('div');
	const cardBody = document.createElement('div');
	const widgetFrame = document.createElement('div');
	const tableFooter = document.createElement('div');
	const getAPIButton = document.createElement('a');
	const showMoreButton = document.createElement('a');
	const loader = document.createElement('div');
	const blinkerWrapper = document.createElement('div');
	loader.classList.add('lds-dual-ring');
	getAPIButton.classList.add('badge', 'badge-secondary', 'open-btn', 'bg-success', 'get-api');
	getAPIButton.setAttribute('role', 'button');
	getAPIButton.setAttribute('target', '_blank');
	getAPIButton.textContent = 'Get Streaming API';
	showMoreButton.classList.add('more-link');
	showMoreButton.textContent = 'Show more...';
	showMoreButton.style.display = 'none';
	showMoreButton.style.cursor = 'pointer';
	tableFooter.style.display = 'flex';
	tableFooter.style.justifyContent = 'end';
	tableFooter.appendChild(showMoreButton);
	tableFooter.appendChild(getAPIButton);
	widgetHeader.classList.add('card-header');
	row.classList.add('row');
	col8.classList.add('col');
	cardBody.classList.add('card-body', 'text-center');
	widgetFrame.classList.add('widget-container', 'tabulator');
	widgetFrame.style.height = 'fit-content';
	componentContainer.appendChild(widgetHeader);
	componentContainer.appendChild(cardBody);
	cardBody.appendChild(widgetFrame);
	cardBody.appendChild(tableFooter);
	widgetHeader.appendChild(row);
	row.appendChild(col8);
	const onloadmetadata = queryMetaData => {
		col8.textContent = queryMetaData?.name || 'No query presented';
		if (queryMetaData.query.match(/subscription[^a-zA-z0-9]/gm)) {
			const liveSpan = document.createElement('span');
			const blinker = document.createElement('div');
			blinkerWrapper.classList.add('col-4', 'text-success', 'text-right');
			blinker.classList.add('blink', 'blnkr', 'bg-success');
			row.appendChild(blinkerWrapper);
			liveSpan.classList.add('d-none', 'd-sm-inline');
			liveSpan.textContent = 'Live';
			blinkerWrapper.appendChild(liveSpan);
			blinkerWrapper.appendChild(blinker);
		}
	};
	const onquerystarted = () => {
		cardBody.appendChild(loader);
	};
	const onqueryend = () => {
		cardBody.removeChild(loader);
	};
	const onerror = error => {
		if (row.contains(blinkerWrapper)) {
			row.removeChild(blinkerWrapper);
		}
		cardBody.textContent = '';
		cardBody.classList.add('alert', 'alert-danger');
		cardBody.setAttribute('role', 'alert');
		const title = document.createElement('h4');
		title.classList.add('alert-heading');
		const errorText = document.createElement('div');
		errorText.classList.add('mb-0');
		cardBody.appendChild(title);
		cardBody.appendChild(errorText);
		title.textContent = 'An error occurred while executing the request. Please, try again later';
		if (Array.isArray(error)) {
			errorText.textContent = `Error: ${error[0].message}`;
		} else if ('message' in error) {
			errorText.textContent = `Error: ${error.message}`;
		} else {
			errorText.textContent = `Error: ${error}`;
		}
	};
	return {
		frame: widgetFrame,
		button: getAPIButton,
		button2: showMoreButton,
		onloadmetadata,
		onquerystarted,
		onqueryend,
		onerror,
	};
}
