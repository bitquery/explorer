export default function renderTokenLink(data,variables) {
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.setAttribute('class', 'text-truncate');
	link.textContent = data.currency;
	if(!data.currency){
		link.textContent = data.smartContract;
	}
	link.href = `/${variables.networkForURL}/token/${data.smartContract}/nft_smart_contract`; // Change  URL
	div.appendChild(link);
	console.log('renderTokenLink data',data)
	console.log('renderTokenLink variables',variables)
	return div;
}
