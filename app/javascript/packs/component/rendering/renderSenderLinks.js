export default function renderSenderLinks(str) {
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.href = `https://explorer.bitquery.io/ethereum/address/${str}`; // Change  URL
	link.textContent = str;

	span.appendChild(link);

	return span;
}
	