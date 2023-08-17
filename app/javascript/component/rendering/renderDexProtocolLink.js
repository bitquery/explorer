export default function renderDexProtocolLink(data,variables,chainId) {
	const span = document.createElement('span');
	const link = document.createElement('a');
	link.textContent = `${data.ProtocolFamily} ${data.ProtocolVersion}`
	link.setAttribute('target', '_blank');
	// link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/dex_protocol/${data.ProtocolName}/nft_dex_protocol`;
	link.href = `/${WidgetConfig.getNetwork(chainId)}/dex_protocol/${data.ProtocolName}/nft_dex_protocol`;
	link.setAttribute('title',`${data.ProtocolFamily} ${data.ProtocolVersion}`)
	
	span.appendChild(link);

	return span;
}
