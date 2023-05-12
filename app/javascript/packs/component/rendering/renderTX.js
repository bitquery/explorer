export default function renderTX(str) {
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.href = `/ethereum/tx/${str}`; // Change  URL
	link.textContent = str;

	return link;
}
