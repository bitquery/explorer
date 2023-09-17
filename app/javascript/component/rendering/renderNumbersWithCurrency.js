export default function renderNumbersWithCurrency(data, variables, chainId) {
    const container = document.createElement('div');
    container.style.display = 'flex';
    container.style.gap = '0 6px';
    container.style.justifyContent = 'end';

    const div = document.createElement('div');
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';
    div.setAttribute('title', data);

    const span = document.createElement('span');
    div.appendChild(span);

    const spanCurrency = document.createElement('span');
    spanCurrency.textContent = WidgetConfig.getCurrency(chainId);
    container.appendChild(div);
    container.appendChild(spanCurrency);

    let content;
    if (/^-?\d+$/.test(data)) {
        const bigIntValue = BigInt(data);
        content = (bigIntValue > Number.MAX_SAFE_INTEGER || bigIntValue < Number.MIN_SAFE_INTEGER) ? data : parseFloat(+data);
    } else {
        content = parseFloat(data);
    }

    span.textContent = content;
    return container;
}
