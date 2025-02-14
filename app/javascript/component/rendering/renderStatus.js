export default data => {
    const isSuccess = data === true || data === 'Success'
    const span = document.createElement('span')
    Object.assign(span.style, {
        fontSize: '1.2em',
        color: isSuccess ? 'green' : 'red',
        display: 'block',
        textAlign: 'right'
    })
    span.textContent = isSuccess ? '✓' : '✗'
    return span
}
