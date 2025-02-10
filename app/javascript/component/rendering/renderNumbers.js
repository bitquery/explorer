export default function renderNumbers(data) {
    const div = document.createElement('div')
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;'
    const span = document.createElement('span')
    span.textContent = (data === null || data === undefined) ? '' : data.toString().replace(/(\.\d*?[1-9])0+$/, '$1').replace(/\.0+$/, '')
    div.setAttribute('title', data)
    div.appendChild(span)

    return div
}
