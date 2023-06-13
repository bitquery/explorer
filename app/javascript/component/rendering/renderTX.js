export default function renderTX(str,variables,chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	link.href = `${process.env.EXPLORER_URL}/${WidgetConfig.getNetwork(chainId)}/tx/${str}`;
	link.textContent = str;
	div.appendChild(link)
	return div;
}		
