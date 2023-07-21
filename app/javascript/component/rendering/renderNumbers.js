export default function renderNumbers(data) {
	const span = document.createElement('span');
	// const text = parseFloat(Number(data).toFixed(4))
	span.textContent = data;
	span.setAttribute('title',data)

	return span;
}
