import WidgetConfig from '../componentDescription/WidgetConfig'
export default function renderTX(str,variables,chainId) {
	const blockchainsData =  new WidgetConfig()
	const div = document.createElement('div');
	div.classList.add('text-truncate')
	const link = document.createElement('a');
	// link.setAttribute('target', 'blank');
		let network;
	blockchainsData.blockchainsInfo.forEach(element => {
	if(element.chainId === chainId){
		return network=element.network
	}
	})
	link.href = `/${network}/tx/${str}`; // Change  URL
	link.textContent = str;
	div.appendChild(link)
	return div;
}		
