export default function renderNumberWithUSD(data) {
    const container = document.createElement('div');
    container.style.cssText = 'display: flex; flex-direction: row; gap: 0px 6px; justify-content: end; text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';

    const amountDiv = document.createElement('div');
    amountDiv.style.cssText = 'font-size: 1em; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;';

    const usdDiv = document.createElement('div');
    usdDiv.style.cssText = 'font-size: 0.75em; color: green;';

    const formatNumberMix = (value, numberFix = 2) => {
        let number = parseFloat(value);

        if (isNaN(number) || Math.abs(number) < 1e-6) return '0';

        if (number === 0) return '0';

        let effectiveFix = numberFix;
        if (Math.abs(number) < 1) {
            const significantDigits = numberFix;
            const leadingZeros = -Math.floor(Math.log10(Math.abs(number)));
            effectiveFix = significantDigits + leadingZeros - 1;
        }

        let units = ['', 'K', 'M', 'B'];
        let unitIndex = 0;
        while (Math.abs(number) >= 1000 && unitIndex < units.length - 1) {
            number /= 1000;
            unitIndex++;
        }

        let fixedNumber = number.toFixed(effectiveFix);
        fixedNumber = fixedNumber.replace(/\.?0+$/, '');

        if (fixedNumber.includes('.')) {
            const [integerPart, decimalPart] = fixedNumber.split('.');
            const zerosMatch = decimalPart.match(/^0+/);
            if (zerosMatch && zerosMatch[0].length > 2) {
                const zerosCount = zerosMatch[0].length;
                const significantPart = decimalPart.slice(zerosCount);
                return `${integerPart}.0..${significantPart}${units[unitIndex]}`;
            }
        }
        return fixedNumber + units[unitIndex];
    };

    const amount = data?.amount !== undefined && data.amount !== null
        ? formatNumberMix(data.amount)
        : '';
    const usd = data?.usd
        ? `$${parseFloat(data.usd).toFixed(2).replace(/(\.\d*?[1-9])0+$/, '$1').replace(/\.0+$/, '')}`
        : '$-';

    amountDiv.textContent = amount || '0';
    usdDiv.textContent = usd;

    container.setAttribute('title', `Amount: ${data?.amount || ''}, USD: ${data?.usd ? `$${parseFloat(data.usd).toFixed(2)}` : ''}`);
    container.appendChild(amountDiv);
    container.appendChild(usdDiv);

    return container;
}