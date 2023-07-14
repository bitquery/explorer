export default function renderNumbers(data, variables, chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const span = document.createElement('span');
	span.textContent = data

	div.appendChild(span)
	return div;
}