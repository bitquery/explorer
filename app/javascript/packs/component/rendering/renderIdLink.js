export default function renderIdLink(data) {
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.setAttribute('target', '_blank');
	link.textContent = data.id;
	if(!data){
		link.textContent = '—';
	}
	link.href = `/ethereum/token/${data.address}/id/${data.id}`; // Change  URL

	span.appendChild(link);

	return span;
}
