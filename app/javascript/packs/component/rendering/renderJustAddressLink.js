import WidgetConfig from '../componentDescription/WidgetConfig'
export default function renderJustAddressLink(data, variables, chainId) {
	const blockchainsData =  new WidgetConfig()
  const div = document.createElement('div');
  div.classList.add('text-truncate');
  const link = document.createElement('a');
  link.setAttribute('target', '_blank');
  let network;
  blockchainsData.blockchainsInfo.forEach(element => {
    if (element.chainId === chainId) {
      return (network = element.network);
    }
  });
  link.href = `/${network}/address/${data}`; // Change  URL
  link.textContent = data;

  div.appendChild(link);
  return div;
}
