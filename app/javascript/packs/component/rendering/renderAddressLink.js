export default function renderAddressLink(str) {
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.href = `https://explorer.bitquery.io/ethereum/address/${str}`; // Change  URL
	link.textContent = str;
	return link;
}
	