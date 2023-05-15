export default function renderAddressLink(data) {
	const link = document.createElement('a');
	link.setAttribute('target', '_blank');
	if(data.smartContract){
		link.href = `/ethereum/address/${data.smartContract}/nft_address`; // Change  URL
		link.textContent = data.currency
	} else{
		link.href = `/ethereum/address/${data}/nft_address`; // Change  URL
		link.textContent = data
	}
	return link;
}
	