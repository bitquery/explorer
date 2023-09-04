export default function renderMethodLink(data, variables, chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
    link.setAttribute('title',data.method)

    // link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/method/${data.hash}`;
    link.href = `/${WidgetConfig.getNetwork(chainId)}/method/${data.hash}`;
    link.textContent = data.method || ''

	div.appendChild(link)
	return div;
}