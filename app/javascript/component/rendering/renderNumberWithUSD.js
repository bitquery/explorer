export default function renderNumberWithUSD(data) {
    const container = document.createElement('div');

    container.style.cssText = 'display: flex; flex-direction: row; gap: 0px 6px; justify-content: end; text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';

    const amountDiv = document.createElement('div');
    amountDiv.style.cssText = 'font-size: 1em; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';

    const usdDiv = document.createElement('div');
    usdDiv.style.cssText = 'font-size: 0.75em; color: green;';

    const amount = data && data.amount ? parseFloat(data.amount).toFixed(2) : '';
    const usd = data && data.usd ? `$${parseFloat(data.usd).toFixed(2)}` : '';

    const formattedAmount = amount.replace(/(\.\d*?[1-9])0+$/, '$1').replace(/\.0+$/, '');
    const formattedUsd = usd.replace(/(\.\d*?[1-9])0+$/, '$1').replace(/\.0+$/, '');

    amountDiv.textContent = formattedAmount;
    usdDiv.textContent = formattedUsd;

    const rawAmount = data && data.amount ? data.amount.toString() : '';
    const rawUsd = data && data.usd ? `$${parseFloat(data.usd).toFixed(2)}` : '';
    container.setAttribute('title', `Amount: ${rawAmount}, USD: ${rawUsd}`);

    container.appendChild(amountDiv);
    container.appendChild(usdDiv);

    return container;
}