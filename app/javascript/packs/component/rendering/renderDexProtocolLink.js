export default function renderDexProtocolLink(data) {
	const span = document.createElement('span');
	const link = document.createElement('a');
   link.textContent = `${data.ProtocolFamily} ${data.ProtocolVersion}`
	link.setAttribute('target', 'blank');
	link.href = `https://explorer.bitquery.io/ethereum/dex_protocol/${data.ProtocolName}`; // Change  URL
	span.appendChild(link);

	return span;
}
