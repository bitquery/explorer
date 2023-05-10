export default function renderIdLink(data) {
   console.log('data from link for id', data)
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.textContent = data;
	if(!data){
		link.textContent = '—';
	}
	link.href = `https://explorer.bitquery.io/ethereum/token/id/${data}`; // Change  URL

	span.appendChild(link);

	return span;
}
