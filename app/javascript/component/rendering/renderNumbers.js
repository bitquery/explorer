export default function renderNumbers(data) {
    const div = document.createElement('div');
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';

    const span = document.createElement('span');
    span.textContent = parseFloat(+data);

    div.setAttribute('title', data);
    div.appendChild(span);

    return div;
}
