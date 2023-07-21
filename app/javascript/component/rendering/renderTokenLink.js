export default function renderTokenLink(data, variables, chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	div.style.maxWidth = '200px'
	const link = document.createElement('a');
	link.textContent = data.currency;
	link.setAttribute('title', data.currency)

	if (!data.currency) {
		link.textContent = data.smartContract;
		link.setAttribute('title', data.smartContract)

	}
	link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/token/${data.smartContract}/nft_smart_contract`;
	div.appendChild(link);
	return div;
}
