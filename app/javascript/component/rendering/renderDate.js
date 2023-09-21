export default function renderDate(sub) {
	const div = document.createElement('div');
	div.textContent = sub.replace('T', ' ').replace('Z', '');
	div.setAttribute('title',sub.replace('T', ' ').replace('Z', ''))

	return div;
}
