export default function renderNumbersWithCurrencySymbol(data, variables, chainId) {
    const container = document.createElement('div')
    container.style.cssText = 'display: flex; flex-direction: row; gap: 0px 6px; justify-content: end;'

    const div = document.createElement('div')
    div.style.cssText = 'text-align: end; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;'
    div.setAttribute('title', data.number)

    const span = document.createElement('span')
    span.setAttribute('title', data.number)
    div.appendChild(span)

    const spanCurrency = document.createElement('span')
    spanCurrency.textContent = data.symbol ? data.symbol : ''
    container.appendChild(div)
    container.appendChild(spanCurrency)

    const formatNumberMix = (value, numberFix = 2) => {
        let number = parseFloat(value)
        if (isNaN(number)) return 'NaN'
        if (number === 0) return '0'
        let effectiveFix = numberFix
        if (Math.abs(number) < 1) {
            const significantDigits = numberFix
            const leadingZeros = -Math.floor(Math.log10(Math.abs(number)))
            effectiveFix = significantDigits + leadingZeros - 1
        }
        let units = ['', 'K', 'M', 'B']
        let unitIndex = 0
        while (Math.abs(number) >= 1000 && unitIndex < units.length - 1) {
            number /= 1000
            unitIndex++
        }
        let fixedNumber = number.toFixed(effectiveFix)
        fixedNumber = fixedNumber.replace(/\.?0+$/, '')
        if (fixedNumber.includes('.')) {
            const [integerPart, decimalPart] = fixedNumber.split('.')
            const zerosMatch = decimalPart.match(/^0+/)
            if (zerosMatch && zerosMatch[0].length > 2) {
                const zerosCount = zerosMatch[0].length
                const significantPart = decimalPart.slice(zerosCount)
                return `${integerPart}.0..${significantPart}${units[unitIndex]}`
            }
        }
        return fixedNumber + units[unitIndex]
    }

    const stringData = (data.number === null || data.number === undefined) ? '' : data.number.toString()
    const formattedData = formatNumberMix(stringData)

    span.textContent = formattedData

    return container
}