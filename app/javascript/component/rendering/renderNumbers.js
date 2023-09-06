// export default function renderNumbers(data) {
//     const div = document.createElement('div');
//     div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';
//
//     const span = document.createElement('span');
//     span.textContent = parseFloat(+data);
//
//     div.setAttribute('title', data);
//     div.appendChild(span);
//
//     return div;
// }
export default function renderNumbers(data) {
    const div = document.createElement('div');
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';
    const span = document.createElement('span');
    if (typeof data === 'bigint' || (typeof data === 'string' && data.length > 15)) {
        span.textContent = data.toString();
    } else {
        const floatData = parseFloat(data);
        if (floatData === 0) {
            span.textContent = '0';
        } else {
            span.textContent = floatData;
        }
    }

    div.setAttribute('title', data);
    div.appendChild(span);

    return div;
}
