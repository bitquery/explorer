export default function renderDate(sub) {
	const span = document.createElement('div');
	const result = new Date(sub).toUTCString();
	span.textContent = result;
	return span;
}
