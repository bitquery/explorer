import WidgetConfig from '../componentDescription/WidgetConfig'
export default function renderDexProtocolLink(data,variables,chainId) {
	const blockchainsData =  new WidgetConfig()
	const span = document.createElement('span');
	const link = document.createElement('a');
   link.textContent = `${data.ProtocolFamily} ${data.ProtocolVersion}`
	link.setAttribute('target', '_blank');
	let network;
	blockchainsData.blockchainsInfo.forEach(element => {
	if(element.chainId === chainId){
		return network=element.network
	}
	})
	link.href = `/${network}/dex_protocol/${data.ProtocolName}/nft_dex_protocol`; // Change  URL
	span.appendChild(link);

	return span;
}
