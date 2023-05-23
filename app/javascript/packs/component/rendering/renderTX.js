export default function renderTX(str,variables) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	// link.setAttribute('target', 'blank');
	link.href = `/${variables.networkForURL}/tx/${str}`; // Change  URL
	link.textContent = str;
	div.appendChild(link)
	return div;
}		
