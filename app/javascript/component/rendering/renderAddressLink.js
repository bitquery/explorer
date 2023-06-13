export default function renderAddressLink(data, variables, chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	
	if(data.smartContract) {
		link.href = `${process.env.EXPLORER_URL}/${WidgetConfig.getNetwork(chainId)}/${variables.address}/${data.smartContract}/nft_address`;
		link.textContent = data.currency
	} else {
		link.href = `${process.env.EXPLORER_URL}/${WidgetConfig.getNetwork(chainId)}/address/${data}/nft_address`;
		link.textContent = data
	}

	div.appendChild(link)
	return div;
}