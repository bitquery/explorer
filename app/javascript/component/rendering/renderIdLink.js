export default function renderIdLink(data, variables, chainId) {
  const div = document.createElement('div');
  div.classList.add('text-truncate');
  const link = document.createElement('a');
  link.textContent = data.id;
  if (!data) {
    link.textContent = '—';
  }
  link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/token/${data.address}/id/${data.id}`;
  link.setAttribute('title',data.id)
  div.appendChild(link);

  return div;
}
