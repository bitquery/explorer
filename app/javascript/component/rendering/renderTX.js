import WidgetConfig from '../componentDescription/WidgetConfig'
export default function renderTX(str,variables,chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	// link.setAttribute('target', 'blank');
	link.href = `/${WidgetConfig.getNetwork(chainId)}/tx/${str}`; // Change  URL
	link.textContent = str;
	div.appendChild(link)
	return div;
}		
