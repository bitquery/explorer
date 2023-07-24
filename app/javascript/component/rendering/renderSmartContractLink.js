export default function renderSmartContractLink(data, variables, chainId) {
  const div = document.createElement('div');
  div.classList.add('text-truncate');
  const link = document.createElement('a');
  link.setAttribute('target', '_blank');
  link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/smart_contract/${data}`;
  link.textContent = data;
  link.setAttribute('title',data)

  div.appendChild(link);
  return div;
}
