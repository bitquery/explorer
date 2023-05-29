export default function renderJustAddressLink(data, variables) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	link.setAttribute('target', '_blank');
	link.href = `/${variables.networkForURL}/address/${data}`; // Change  URL
	link.textContent = data

	div.appendChild(link)
	return div;
}