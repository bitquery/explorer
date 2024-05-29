export default function renderNumbersWithCurrencySymbol(data, variables, chainId) {

    const container = document.createElement('div');
    container.style.cssText = 'display: flex; flex-direction: row; gap: 0px 6px; justify-content: end;'

    const div = document.createElement('div');
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';
    div.setAttribute('title', data.number);

    const span = document.createElement('span');
    span.setAttribute('title', data.number);

    div.appendChild(span);
    const spanCurrency = document.createElement('span');
    spanCurrency.textContent = data.symbol ? data.symbol : '';
    container.appendChild(div);
    container.appendChild(spanCurrency);

    const stringData = (data.number === null || data.number === undefined) ? '' : data.number.toString()
    const formattedData = stringData.replace(/(\.\d*?[1-9])0+$/, '$1').replace(/\.0+$/, '')

    span.textContent = formattedData
    return container;
}
