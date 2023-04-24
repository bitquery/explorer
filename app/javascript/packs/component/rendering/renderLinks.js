export default function renderLinks(str) {
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.href = str; // Change  URL
	link.textContent = str;

	span.appendChild(link);

	return span;
}
