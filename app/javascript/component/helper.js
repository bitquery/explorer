const isNotEmptyArray = subj => Array.isArray(subj) && subj.length;
const isNotEmptyObject = subj => !Array.isArray(subj) && typeof subj === 'object' && Object.keys(subj).length;

export function SubscriptionDataSource(payload, onerror) {

	let callback, variables, cleanSubscription

	const subscribe = () => {
		const currentUrl = payload.endpoint_url.replace(/^http/, 'ws');
		const client = createClient({ url: currentUrl });

		cleanSubscription = client.subscribe({ query: payload.query, variables }, {
			next: ({ data }) => callback(data, variables),
			error: error => { onerror(error) },
			complete: () => {},
		});
	} 

	this.setCallback = cb => {
		callback = cb
	}

	this.changeVariables = async deltaVariables => {
		variables = { ...payload.variables, ...deltaVariables }
		cleanSubscription && cleanSubscription()
		subscribe()
	}

	return this
}

export function HistoryDataSource(payload, widgetFrame) {

	let callback
	let variables = payload.variables

	const getNewData = async () => {
		widgetFrame.onquerystarted()
		const data = await getData({ ...payload, variables })
		widgetFrame.onqueryend()
		callback(data, variables)
	}

	this.setCallback = cb => {
		callback = cb
	}

	this.increaseLimit = async () => {
		variables.limit += 10
		getNewData()
	}

	this.changeVariables = async deltaVariables => {
		if (deltaVariables) {
			variables = { ...payload.variables, ...deltaVariables }
		}
		await getNewData()
	}

	return this
}

export const getBaseClass = (targetClass, config) => {
	// discover functions used in class config function
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

export const getAPIButton = (data, variables, queryID) => () => {
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
	form.appendChild(createHiddenField('variables', JSON.stringify(variables)));
	form.appendChild(createHiddenField('url', queryID));
	document.body.appendChild(form);
	form.submit();
	document.body.removeChild(form);
}

export const increaseLimitButton = (clearData, historyDataSource) => () => {
	clearData()
	historyDataSource.increaseLimit()
}

export const getQueryParams = async (queryID) => {
	const response = await fetch(`${window.bitqueryAPI}/getquery/${queryID}`)
	const { endpoint_url, variables, query, name } = await response.json()
	return {
		variables: JSON.parse(variables),
		query,
		endpoint_url,
		name
	}
}

export const getData = async ({ endpoint_url, query, variables }) => {
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

export const createWidgetFrame = selector => {
	const createButton = title => {
		const button = document.createElement('a');
		button.classList.add('badge', 'badge-secondary', 'open-btn', 'bg-success', 'get-api', 'mr-2');
		button.setAttribute('role', 'button');
		button.setAttribute('target', '_blank');
		button.textContent = title;
		return button
	}
	const componentContainer = document.querySelector(selector);
	const widgetHeader = document.createElement('div');
	const row = document.createElement('div');
	const col8 = document.createElement('div');
	const cardBody = document.createElement('div');
	const widgetFrame = document.createElement('div');
	const tableFooter = document.createElement('div');
	const getStreamingAPIButton = createButton('Get Streaming API')
	const getHistoryAPIButton = createButton('Get History API')
	const showMoreButton = document.createElement('a');
	const loader = document.createElement('div');
	const blinkerWrapper = document.createElement('div');
	loader.classList.add('lds-dual-ring');
	showMoreButton.classList.add('more-link', 'badge');
	showMoreButton.textContent = 'Show more...';
	showMoreButton.style.display = 'none';
	showMoreButton.style.cursor = 'pointer';
	tableFooter.style.display = 'flex';
	tableFooter.style.justifyContent = 'end';
	tableFooter.appendChild(showMoreButton);
	tableFooter.appendChild(getHistoryAPIButton);
	tableFooter.appendChild(getStreamingAPIButton);
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
		getHistoryAPIButton,
		getStreamingAPIButton,
		showMoreButton,
		onloadmetadata,
		onquerystarted,
		onqueryend,
		onerror,
	};
}
