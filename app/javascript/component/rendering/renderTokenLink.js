export default function renderTokenLink(data, variables, chainId) {
	const div = document.createElement('div');
	div.className = 'text-truncate';
	div.style.maxWidth = '200px';

	const text = data.smartContract === '0x' ? data.currency : data.currency || data.smartContract;
	const elem = data.smartContract === '0x' ? document.createElement('span') : document.createElement('a');

	elem.textContent = text;
	elem.title = text;

	if (data.smartContract !== '0x') {
		elem.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/address/${data.smartContract}`;
		// elem.href = `/${WidgetConfig.getNetwork(chainId)}/address/${data.smartContract}`;
	}

	div.appendChild(elem);
	return div;
}
