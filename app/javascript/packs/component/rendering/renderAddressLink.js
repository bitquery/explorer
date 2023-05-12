export default function renderAddressLink(data) {
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.href = `/ethereum/address/${data.smartContract}/nft_address`; // Change  URL
	link.textContent = data.currency
	return link;
}
	