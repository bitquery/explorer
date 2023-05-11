export default function renderTX(str) {
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.href = `https://explorer.bitquery.io/ethereum/tx/${str}`; // Change  URL
	link.textContent = str;

	return link;
}
