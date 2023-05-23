export default function renderAddressLink(data, variables) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	// link.setAttribute('target', '_blank');
	if(data.smartContract){
		link.href = `/${variables.networkForURL}/${variables.address}/${data.smartContract}/nft_address`; // Change  URL
		link.textContent = data.currency
	} else{
		link.href = `/${variables.networkForURL}/address/${data}/nft_address`; // Change  URL
		link.textContent = data
	}

	div.appendChild(link)
	return div;
}