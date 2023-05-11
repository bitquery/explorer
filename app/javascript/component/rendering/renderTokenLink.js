export default function renderTokenLink(data) {
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.textContent = data.currency;
	if(!data.currency){
		link.textContent = '—';
	}
	link.href = `https://explorer.bitquery.io/ethereum/token/${data.smartContract}`; // Change  URL

	span.appendChild(link);

	return span;
}
