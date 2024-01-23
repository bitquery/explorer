export default function renderNumbers(data) {
    const div = document.createElement('div')
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;'
    const span = document.createElement('span')
    const stringData = (data === null || data === undefined) ? '' : data.toString()
    const formattedData = stringData.replace(/(\.\d*?[1-9])0+$/, '$1').replace(/\.0+$/, '')

    span.textContent = formattedData
    div.setAttribute('title', stringData)
    div.appendChild(span)

    return div
}
