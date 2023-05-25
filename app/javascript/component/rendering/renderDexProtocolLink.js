export default function renderDexProtocolLink(data,variables) {
	const span = document.createElement('span');
	const link = document.createElement('a');
   link.textContent = `${data.ProtocolFamily} ${data.ProtocolVersion}`
	link.setAttribute('target', 'blank');
	link.href = `/${variables.networkForURL}/dex_protocol/${data.ProtocolName}/nft_dex_protocol`; // Change  URL
	span.appendChild(link);

	return span;
}
