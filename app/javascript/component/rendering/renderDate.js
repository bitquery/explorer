export default function renderDate(sub) {
	const span = document.createElement('span');
	span.textContent = sub.replace('T', ' ').replace('Z', '');
	span.setAttribute('title',sub.replace('T', ' ').replace('Z', ''))

	return span;
}
