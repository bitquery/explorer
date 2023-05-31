import WidgetConfig from '../componentDescription/WidgetConfig'
export default function renderTokenLink(data,variables,chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	// link.setAttribute('target', '_blank');
	link.setAttribute('class', 'text-truncate');
	link.textContent = data.currency;
	if(!data.currency){
		link.textContent = data.smartContract;
	}
	link.href = `/${WidgetConfig.getNetwork(chainId)}/token/${data.smartContract}/nft_smart_contract`; // Change  URL
	div.appendChild(link);

	return div;
}
