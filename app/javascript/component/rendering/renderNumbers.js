export default function renderNumbers(data, variables, chainId) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const span = document.createElement('span');
	span.textContent = data

console.log('data from rendernumbers',data)
	div.appendChild(span)
	return div;
}