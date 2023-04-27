export default function renderAddressLink(str) {
	const span = document.createElement('span');
	
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.href = `https://explorer.bitquery.io/ethereum/address/${str}`; // Change  URL
	link.textContent = str;
	link.style.width = '100%'
	link.style.textOverflow='ellipsis'

	span.appendChild(link);

	return span;
}
	