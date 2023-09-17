export default function renderNumbers(data) {
    const div = document.createElement('div')
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;'

    const span = document.createElement('span')
    let textContent
    if (/^-?\d+$/.test(data)) {
        const bigIntValue = BigInt(data)
        if (bigIntValue > Number.MAX_SAFE_INTEGER || bigIntValue < Number.MIN_SAFE_INTEGER) {
            textContent = data
        } else {
            textContent = parseFloat(bigIntValue)
        }
    } else {
        textContent = parseFloat(data)
    }
    span.textContent = textContent
    div.setAttribute('title', data)
    div.appendChild(span)
    return div
}
