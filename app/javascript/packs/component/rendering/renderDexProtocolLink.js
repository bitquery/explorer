export default function renderDexProtocolLink(data) {
	const span = document.createElement('span');
	const link = document.createElement('a');
   link.textContent = `${data.ProtocolFamily} ${data.ProtocolVersion}`
	link.setAttribute('target', 'blank');
	link.href = `/ethereum/dex_protocol/${data.ProtocolName}/nft_dex_protocol`; // Change  URL
	span.appendChild(link);

	return span;
}
