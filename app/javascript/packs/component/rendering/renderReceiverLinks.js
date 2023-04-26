export default function renderReceiverLinks(str) {
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.href = `https://explorer.bitquery.io/ethereum/smart_contract/${str}`; // Change  URL
	link.textContent = str;

	span.appendChild(link);

	return span;
}
