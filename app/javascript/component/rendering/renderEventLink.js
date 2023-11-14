export default function renderEventLink(data, variables, chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
    link.setAttribute('title',data.event)

    link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/event/${data.hash}`;
    // link.href = `/${WidgetConfig.getNetwork(chainId)}/event/${data.hash}`;
    link.textContent = data.event || data.hash

	div.appendChild(link)
	return div;
}