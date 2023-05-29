import WidgetConfig from '../componentDescription/WidgetConfig'
export default function renderTokenLink(data,variables,chainId) {
	const blockchainsData =  new WidgetConfig()
	let network;
	blockchainsData.blockchainsInfo.forEach(element => {
	if(element.chainId === chainId){
		return network=element.network
	}
	})
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	link.setAttribute('target', '_blank');
	link.setAttribute('class', 'text-truncate');
	link.textContent = data.currency;
	if(!data.currency){
		link.textContent = data.smartContract;
	}
	link.href = `/${network}/token/${data.smartContract}/nft_smart_contract`; // Change  URL
	div.appendChild(link);

	return div;
}
