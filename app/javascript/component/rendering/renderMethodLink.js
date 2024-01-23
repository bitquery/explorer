export default function renderMethodLink(data, variables, chainId) {
    if(!data) return
    const div = document.createElement('div');
    div.classList.add('text-truncate')
    let link = document.createElement('a');

    // link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/method/${data.hash}`;
    link.href = `/${WidgetConfig.getNetwork(chainId)}/method/${data.hash}`;
    link.textContent = data.method || data.hash
    link.setAttribute('title', data.method)

    if (!data.hash && data.hash.length < 1) {
        link = document.createElement('span')
        link.textContent = `value: ${parseFloat(+data.value)}`
        link.setAttribute('title', data.value)

    }
    div.appendChild(link)
    return div;
}