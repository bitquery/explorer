export default function renderTokenLink(data) {
	//network
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.textContent = data.currency;
	if(!data.currency){
		link.textContent = '—';
	}
	link.href = `/ethereum/token/${data.smartContract}/nft`; // Change  URL

	span.appendChild(link);

	return span;
}
