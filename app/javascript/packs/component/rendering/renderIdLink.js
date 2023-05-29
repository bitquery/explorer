import WidgetConfig from '../componentDescription/WidgetConfig'
export default function renderIdLink(data, variables, chainId) {
	const blockchainsData =  new WidgetConfig()
  const div = document.createElement('div');
  div.classList.add('text-truncate');
  const link = document.createElement('a');
  link.setAttribute('target', '_blank');
  link.textContent = data.id;
  let network;
  blockchainsData.blockchainsInfo.forEach(element => {
    if (element.chainId === chainId) {
      return (network = element.network);
    }
  });
  if (!data) {
    link.textContent = '—';
  }

  link.href = `/${network}/token/${data.address}/id/${data.id}`; // Change  URL

  div.appendChild(link);

  return div;
}
