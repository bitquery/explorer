export default function renderPairLink(data, variables, chainId) {
    const div = document.createElement('div')
    div.classList.add('text-truncate')
    div.style.whiteSpace = 'nowrap'
    div.style.overflow = 'hidden'
    div.style.textOverflow = 'ellipsis'

    const link = document.createElement('a')
    link.textContent = `${data.buyCurrencySymbol || data.buyCurrencySC.slice(0,7)+'...'} / ${data.sellCurrencySymbol || data.sellCurrencySC.slice(0,7)+'...'}`
    link.setAttribute('title', `${data.buyCurrencySymbol || data.buyCurrencySC} / ${data.sellCurrencySymbol || data.sellCurrencySC}`)
    link.href = `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/tokenpair/${data.buyCurrencySC}/${data.sellCurrencySC}`
    // link.href = `/${WidgetConfig.getNetwork(chainId)}/tokenpair/${data.buyCurrencySC}/${data.sellCurrencySC}`
    div.appendChild(link)
    return div
}