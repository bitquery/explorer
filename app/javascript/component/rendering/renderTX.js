export default function renderTX(str,variables,chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	// link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/tx/${str}`;
	link.href = `/${WidgetConfig.getNetwork(chainId)}/tx/${str}`;
	link.textContent = str;
	link.setAttribute('title',str)

	div.appendChild(link)
	return div;
}
