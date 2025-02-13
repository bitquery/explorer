export default function renderPairLink(data, variables, chainId) {
    const div = document.createElement('div');
    div.classList.add('text-truncate'); // Добавляем класс для стилизации
    div.style.whiteSpace = 'nowrap';   // Запрещаем перенос строк
    div.style.overflow = 'hidden';     // Скрываем переполнение
    div.style.textOverflow = 'ellipsis'; // Добавляем троеточие

    const link = document.createElement('a');
    link.textContent = `${data.buyCurrencySymbol} / ${data.sellCurrencySymbol}`;
    link.setAttribute('title', `${data.buyCurrencySymbol} / ${data.sellCurrencySymbol}`); // Подсказка при наведении
    link.href = `/${WidgetConfig.getNetwork(chainId)}/tokenpair/${data.buyCurrencySC}/${data.sellCurrencySC}`;
    div.appendChild(link);
    return div;
}