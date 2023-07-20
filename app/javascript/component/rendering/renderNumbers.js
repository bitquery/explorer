export default function renderNumbers(data) {
	const div = document.createElement('div');
	div.style.textAlign='end'
	const span = document.createElement('span');
	span.textContent = parseFloat(Number(data).toFixed(4));

	div.appendChild(span)
	return div;
}
