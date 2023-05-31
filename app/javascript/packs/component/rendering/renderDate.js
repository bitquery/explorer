export default function renderDate(sub) {
	const div = document.createElement('div');
	// const result = new Date(sub).toUTCString();
	div.textContent = sub.replace('T', ' ').replace('Z', '');
	return div;
}
