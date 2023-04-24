export default function renderDate(sub) {
	const span = document.createElement('span');

	const result = new Date(sub).toLocaleString();
	span.textContent = result;
	return span;
}
