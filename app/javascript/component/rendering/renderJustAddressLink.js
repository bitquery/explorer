export default function renderJustAddressLink(data, variables, chainId) {
  const div = document.createElement('div');
  div.classList.add('text-truncate');
  const link = document.createElement('a');
  link.setAttribute('target', '_blank');
  link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/address/${data}`;
  // link.href = `/${WidgetConfig.getNetwork(chainId)}/address/${data}`;
  link.textContent = data;
  link.setAttribute('title',data)

  div.appendChild(link);
  return div;
}
