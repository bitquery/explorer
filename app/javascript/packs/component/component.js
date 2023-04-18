const graphqlQuerySubscriptionExecutor = async (
  url,
  query,
  componentObject,
  element,
  variables,
  onerror
) => {
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

const graphqlQueryExecutor = async (
  url,
  query,
  element,
  variables,
  api_key = ''
) => {
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

const renderQueryInComponent = async (
  endpoint_url,
  componentObject,
  query,
  compElement,
  variables,
  api_key
) => {
  const graphQLResponse = await graphqlQueryExecutor(
    endpoint_url,
    query,
    compElement,
    variables,
    api_key
  );
  componentObject.onData(graphQLResponse.data);
};

const prepopulateQuery = async (
  ideApiUrl,
  url,
  componentObject,
  compElement,
  query,
  queryVariables,
  prePopulateId,
  api_key
) => {
  const startQuery = query;
  let finalQuery = startQuery;
  if (prePopulateId) {
    const response = await fetch(`${ideApiUrl}/getquery/${prePopulateId}`);
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
      finalQuery = startQuery
        .replace(/^subscription/, 'query')
        .replace(/Transfers\(/, 'Transfers(limit: {count: 15}');
    }
  }
  await renderQueryInComponent(
    url,
    componentObject,
    finalQuery,
    compElement,
    queryVariables,
    api_key
  );
};

const createWidgetFrame = (ideApiUrl, selector, queryId) => {
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
  getAPIButton.classList.add(
    'badge',
    'badge-secondary',
    'open-btn',
    'bg-success',
    'get-api'
  );
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
    form.setAttribute('action', `${ideApiUrl}/widgetconfig`);
    form.setAttribute('enctype', 'application/json');
    form.setAttribute('target', '_blank');
    console.log(serialize(BootstrapTableComponent));
    console.log(serialize(NFTStartTable));
    form.appendChild(
      createHiddenField('base', serialize(BootstrapTableComponent))
    );
    form.appendChild(createHiddenField('widget', serialize(NFTStartTable)));
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
    title.textContent =
      'An error occurred while executing the request. Please, try again later';
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

export default async function renderComponent(
  ideApiUrl,
  component,
  selector,
  queryId,
  prePopulateId,
  api_key,
  variables
) {
  const widgetFrame = createWidgetFrame(ideApiUrl, selector, queryId);
  let queryMetaData;
  try {
    const response = await fetch(`${ideApiUrl}/getquery/${queryId}`);
    if (response.status === 200) {
      try {
        queryMetaData = await response.json();
      } catch (error) {
        throw new Error('There is no such querie with same url...');
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
        ideApiUrl,
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
