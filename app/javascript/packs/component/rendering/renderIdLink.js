export default function renderIdLink(data) {
   console.log('data from link for id', data)
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.setAttribute('target', 'blank');
	link.textContent = data.id;
	if(!data){
		link.textContent = '—';
	}
	link.href = `/ethereum/token/${data.address}/id/${data.id}`; // Change  URL

	span.appendChild(link);

	return span;
}
