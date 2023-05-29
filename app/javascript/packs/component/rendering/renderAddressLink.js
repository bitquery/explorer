import WidgetConfig from '../componentDescription/WidgetConfig'
export default function renderAddressLink(data, variables, chainId) {
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
	if(data.smartContract){
		link.href = `/${network}/${variables.address}/${data.smartContract}/nft_address`; // Change  URL
		link.textContent = data.currency
	} else{
		link.href = `/${network}/address/${data}/nft_address`; // Change  URL
		link.textContent = data
	}

	div.appendChild(link)
	return div;
}