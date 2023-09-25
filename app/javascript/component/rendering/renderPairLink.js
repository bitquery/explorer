export default function renderPairLink(data,variables, chainId) {
    const div = document.createElement('div');
    div.classList.add('text-truncate');
    const elementType = data.buyCurrencySC.length > 2 && data.sellCurrencySC.length > 3 ? 'a' : 'span';
    const link = document.createElement(elementType);
    link.textContent = `${data.buyCurrencySymbol} / ${data.sellCurrencySymbol}`;
    link.setAttribute('title', `${data.buyCurrencySymbol} / ${data.sellCurrencySymbol}`)

    if (elementType === 'a') {
        link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/tokenpair/${data.buyCurrencySC}/${data.sellCurrencySC}`;
    }
    div.appendChild(link);

    return div;
}
