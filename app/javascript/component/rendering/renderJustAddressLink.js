export default function renderJustAddressLink(data, variables, chainId) {
  const div = document.createElement('div');
  div.classList.add('text-truncate');

  if (data === '0x') {
    const span = document.createElement('span');
    span.textContent = '0x'
    span.setAttribute('title', `0x`);
    div.appendChild(span);
  } else {
    const link = document.createElement('a');
    link.setAttribute('target', '_blank');
    // link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/address/${data}`;
    link.href = `/${WidgetConfig.getNetwork(chainId)}/address/${data}`;
    link.textContent = data;
    link.setAttribute('title', data);
    div.appendChild(link);
  }

  return div;
}
