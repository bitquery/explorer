export default function renderNumbers(data) {
	const div = document.createElement('div');
	div.style.textAlign = 'end'
	const span = document.createElement('span');
	// const text = parseFloat(Number(data).toFixed(4))
	span.textContent = data;
	div.setAttribute('title', data)
	div.style.whiteSpace = 'nowrap';
	div.style.overflow = 'hidden';
	div.style.textOverflow = 'ellipsis';
	div.appendChild(span)
	return div;
}
