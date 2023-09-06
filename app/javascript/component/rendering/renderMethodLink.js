export default function renderMethodLink(data, variables, chainId) {
	const content = data.method || data.hash;
	// const href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/method/${data.hash}`;
	const href = `/${WidgetConfig.getNetwork(chainId)}/method/${data.hash}`;

	const div = document.createElement('div');
	div.classList.add('text-truncate');

	const link = document.createElement(data.method ? 'a' : 'span');
	link.textContent = content;

	if (data.method) {
		link.setAttribute('title', content);
		link.href = href;
	}

	div.appendChild(link);
	return div;
}
