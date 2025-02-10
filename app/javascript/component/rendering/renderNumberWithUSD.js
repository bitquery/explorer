export default function renderNumberWithUSD(data) {
    const container = document.createElement('div');
    container.style.cssText = 'display: flex; flex-direction: row; gap: 0px 6px; justify-content: end; text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';

    const amountDiv = document.createElement('div');
    amountDiv.style.cssText = 'font-size: 1em; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';

    const usdDiv = document.createElement('div');
    usdDiv.style.cssText = 'font-size: 0.75em; color: green;';

    const amount = data?.amount ? parseFloat(data.amount).toFixed(2).replace(/(\.\d*?[1-9])0+$/, '$1').replace(/\.0+$/, '') : '';
    const usd = data?.usd ? `$${parseFloat(data.usd).toFixed(2).replace(/(\.\d*?[1-9])0+$/, '$1').replace(/\.0+$/, '')}` : '';

    amountDiv.textContent = amount;
    usdDiv.textContent = usd;

    container.setAttribute('title', `Amount: ${data?.amount || ''}, USD: ${data?.usd ? `$${parseFloat(data.usd).toFixed(2)}` : ''}`);

    container.appendChild(amountDiv);
    container.appendChild(usdDiv);

    return container;
}
