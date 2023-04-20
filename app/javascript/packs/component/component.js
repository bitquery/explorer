const graphqlQuerySubscriptionExecutor = async (url, query, componentObject, element, variables, onerror) => {
	const currentUrl = url.replace(/^http/, 'ws');
	const client = createClient({ url: currentUrl });
	const payload = { query, variables: variables };

	client.subscribe(payload, {
		next: (data) => {
			const sub = 'subscription';
			componentObject.onData(data.data, sub);
		},
		error: (error) => {
			onerror(error);
			console.log('graphqlQuerySubscriptionExecutor', error);
		},
		complete: () => console.log('complete'),
	});
};

const graphqlQueryExecutor = async (url, query, element, variables, api_key = '') => {
	let keyHeader = { 'X-API-KEY': api_key };
	const response = await fetch(url, {
		method: 'POST',
		headers: {
			Accept: 'application/json',
			'Content-Type': 'application/json',
			...keyHeader,
		},
		body: JSON.stringify({ query, variables }),
		credentials: 'same-origin',
	});
	if (response.status !== 200) {
		throw new Error(response.error);
	}
	const data = await response.json();
	if (data.errors) {
		throw new Error(data.errors[0].message);
	}
	return data;
};

const renderQueryInComponent = async (endpoint_url, componentObject, query, compElement, variables, api_key) => {
	const graphQLResponse = await graphqlQueryExecutor(endpoint_url, query, compElement, variables, api_key);
	componentObject.onData(graphQLResponse.data);
};

const prepopulateQuery = async (url, componentObject, compElement, query, queryVariables, prePopulateId, api_key) => {
	const startQuery = query;
	let finalQuery = startQuery;
	if (prePopulateId) {
		const response = await fetch(`${window.bitqueryAPI}/getquery/${prePopulateId}`);
		let queryMetaData;
		if (response.status === 200) {
			queryMetaData = await response.json();
		} else {
			throw new Error(response.error);
		}
		finalQuery = queryMetaData.query.trim();
		const queryVariables = {
			...JSON.parse(queryMetaData.variables),
			...queryVariables,
		};
	} else {
		if (!query.includes('limit')) {
			// getLimit(query)
			finalQuery = startQuery.replace(/^subscription/, 'query').replace(/Transfers\(/, 'Transfers(limit: {count: 15}');
		}
	}
	await renderQueryInComponent(url, componentObject, finalQuery, compElement, queryVariables, api_key);
};

const createWidgetFrame = (selector, queryId) => {
	const componentContainer = document.querySelector(selector);
	const widgetHeader = document.createElement('div');
	const row = document.createElement('div');
	const col8 = document.createElement('div');
	const cardBody = document.createElement('div');
	const widgetFrame = document.createElement('div');
	const tableFooter = document.createElement('div');
	const getAPIButton = document.createElement('a');
	const loader = document.createElement('div');
	const blinkerWrapper = document.createElement('div');
	loader.classList.add('lds-dual-ring');
	getAPIButton.classList.add('badge', 'badge-secondary', 'open-btn', 'bg-success', 'get-api');
	getAPIButton.setAttribute('target', '_blank');
	getAPIButton.textContent = 'Get Streaming API';
	getAPIButton.onclick = () => {
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
		console.log(serialize(BootstrapTableComponent));
		console.log(serialize(LatestNFTTransfersTable));
		form.appendChild(createHiddenField('base', serialize(BootstrapTableComponent)));
		form.appendChild(createHiddenField('widget', serialize(LatestNFTTransfersTable)));
		form.appendChild(createHiddenField('url', queryId));
		document.body.appendChild(form);
		form.submit();
		document.body.removeChild(form);
	};
	tableFooter.style.textAlign = 'right';
	tableFooter.appendChild(getAPIButton);
	widgetHeader.classList.add('card-header');
	row.classList.add('row');
	col8.classList.add('col-8');
	cardBody.classList.add('card-body', 'text-center');
	widgetFrame.classList.add('widget-container', 'tabulator');
	widgetFrame.style.height = '470px';
	widgetFrame.style.overflow = 'scroll';
	componentContainer.appendChild(widgetHeader);
	componentContainer.appendChild(cardBody);
	cardBody.appendChild(widgetFrame);
	cardBody.appendChild(tableFooter);
	widgetHeader.appendChild(row);
	row.appendChild(col8);
	const onloadmetadata = (queryMetaData) => {
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
	const onerror = (error) => {
		console.log(error);
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
		onloadmetadata,
		onquerystarted,
		onqueryend,
		onerror,
	};
};

export default async function renderComponent(component, selector, queryId, prePopulateId, api_key, variables) {
	const widgetFrame = createWidgetFrame(selector, queryId);
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
		const componentObject = new component(compElement, queryMetaData);
		const query = queryMetaData.query.trim();
		const queryVariables = {
			...JSON.parse(queryMetaData.variables),
			...variables,
		};
		widgetFrame.onquerystarted();
		if (query.startsWith('subscription')) {
			await prepopulateQuery(
				queryMetaData.endpoint_url,
				componentObject,
				compElement,
				query,
				queryVariables,
				prePopulateId,
				api_key
			);
			graphqlQuerySubscriptionExecutor(
				queryMetaData.endpoint_url,
				query,
				componentObject,
				compElement,
				queryVariables,
				widgetFrame.onerror
			);
		} else {
			await renderQueryInComponent(
				queryMetaData.endpoint_url,
				componentObject,
				query,
				compElement,
				queryVariables,
				api_key
			);
		}
		widgetFrame.onqueryend();
	} catch (error) {
		widgetFrame.onerror(error);
	}
}
// const createImg = async (uri) => {
// 	const div = document.createElement('div');
// 	div.classList.add('text-center');
// 	const img = document.createElement('img');
// 	img.classList.add('rounded');
// 	img.style.maxWidth = '100px';
// 	img.style.maxHeight = '100px';

// 	let url = uri;
// 	if (uri.startsWith('ipfs://')) {
// 		url = url.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/');
// 		console.log(url);
// 	}

// 	if (url.startsWith('https://') || uri.startsWith('data:application/json')) {
// 		const proxy = 'https://api.allorigins.win/raw?url=';
// 		const response = await fetch(uri);
// 		const data = await response.json();
// 		let imgURL;

// 		if (data.image) {
// 			imgURL = data.image;
// 		}
// 		if (data.image_url) {
// 			imgURL = data.image_url;
// 		}
// 		if (imgURL.startsWith('ipfs://')) {
// 			console.log('imgURL.startsWith:', imgURL);
// 			imgURL = imgURL.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/');
// 			console.log('imgURL.replace:', imgURL);
// 		}
// 		console.log('ready img', imgURL);
// 		img.src = imgURL;
// 	}
// 	div.appendChild(img);
// 	console.log(div);
// 	return div;
// };
// createImg(
// 	'data:application/json;base64,eyJuYW1lIjogIk5vdW4gNDAxIDE5NCIsICJkZXNjcmlwdGlvbiI6ICJGb3JnZXJpZXMgLSBBTEwgYXJlIEZBS0UgZXhjZXB0IE9ORS5cblxuV2UndmUgbWl4ZWQgTm91biBpbnRvIGFuIG9wZW4gZWRpdGlvbiBvZiBleGFjdCBmb3JnZXJpZXMuIFNjYW4geW91cnMgYXQgKipmb3JnZXJpZXMud3RmKiogb25jZSB0aGUgZHJvcCBpcyBjb21wbGV0ZS4gT25lIG9mIHlvdSB3aWxsIHdpdGhkcmF3IHRoZSBOb3VuIGZyb20gZXNjcm93ISBDaGFpbmxpbmsgVlJGIGtlZXBzIGl0IGZhaXIsIHRyYW5zcGFyZW50IGFuZCB2ZXJpZmlhYmx5IHJhbmRvbS5cblxuQWlyZHJvcCB0byBPRyBtaW50ZXJzIGlzIHVuZGVyIHdheSEiLCAiaW1hZ2UiOiAiaXBmczovL2JhZnliZWloMmE2ZHRleGlueGJyeDRrb3diYmh0NWwycmx6aHZ2NGVuemV1cm9teHF1N3htdnJrZ2l5IiwgInByb3BlcnRpZXMiOiB7Im51bWJlciI6IDE5NCwgIm5hbWUiOiAiTm91biA0MDEifX0='
// );

//'data:application/json;base64,eyJuYW1lIjogIk5vdW4gNDAxIDE5NCIsICJkZXNjcmlwdGlvbiI6ICJGb3JnZXJpZXMgLSBBTEwgYXJlIEZBS0UgZXhjZXB0IE9ORS5cblxuV2UndmUgbWl4ZWQgTm91biBpbnRvIGFuIG9wZW4gZWRpdGlvbiBvZiBleGFjdCBmb3JnZXJpZXMuIFNjYW4geW91cnMgYXQgKipmb3JnZXJpZXMud3RmKiogb25jZSB0aGUgZHJvcCBpcyBjb21wbGV0ZS4gT25lIG9mIHlvdSB3aWxsIHdpdGhkcmF3IHRoZSBOb3VuIGZyb20gZXNjcm93ISBDaGFpbmxpbmsgVlJGIGtlZXBzIGl0IGZhaXIsIHRyYW5zcGFyZW50IGFuZCB2ZXJpZmlhYmx5IHJhbmRvbS5cblxuQWlyZHJvcCB0byBPRyBtaW50ZXJzIGlzIHVuZGVyIHdheSEiLCAiaW1hZ2UiOiAiaXBmczovL2JhZnliZWloMmE2ZHRleGlueGJyeDRrb3diYmh0NWwycmx6aHZ2NGVuemV1cm9teHF1N3htdnJrZ2l5IiwgInByb3BlcnRpZXMiOiB7Im51bWJlciI6IDE5NCwgIm5hbWUiOiAiTm91biA0MDEifX0='
//'https://ipfs.io/ipfs/QmcFDx8avDtPXWzTFrJbdRd8m7aBJsdV95VsCum8i17qZH/10421'
//'https://tokens.killabears.com/killabits/meta/188/1064'
//'ipfs://QmcFDx8avDtPXWzTFrJbdRd8m7aBJsdV95VsCum8i17qZH/10421'
//'https://trainer-metadata.pixelmon.ai/metadata/5714'
