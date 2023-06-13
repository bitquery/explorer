export default function renderTokenLink(data,variables,chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	link.setAttribute('class', 'text-truncate');
	link.textContent = data.currency;
	if(!data.currency){
		link.textContent = data.smartContract;
	}
	link.href = `${process.env.EXPLORER_URL}/${WidgetConfig.getNetwork(chainId)}/token/${data.smartContract}/nft_smart_contract`;
	div.appendChild(link);
	return div;
}
