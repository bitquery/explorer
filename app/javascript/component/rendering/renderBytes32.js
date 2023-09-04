export default function renderBytes32(data) {
    const div = document.createElement('div')
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 150px;'

    const span = document.createElement('span')
    span.textContent = data

    div.setAttribute('title', data)
    div.appendChild(span)

    return div;
}
