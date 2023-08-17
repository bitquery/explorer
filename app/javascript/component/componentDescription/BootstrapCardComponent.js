export default class BootstrapCardComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.container = element;
		this.config = this.configuration();
		this.wrapper = this.createElementWithClasses('div', 'row');
		this.container.appendChild(this.wrapper);
		this.historyDataSource = historyDataSource
		this.subscriptionDataSource = subscriptionDataSource
	}
	clearData() {
		this.wrapper.textContent = ''
	}
	createElementWithClasses(elementType, ...classes) {
		const element = document.createElement(elementType);
		element.classList.add(...classes);
		return element;
	}

	async init(widgetFrame) {
		if (this.historyDataSource) {
			this.historyDataSource.setCallback(this.onHistoryData.bind(this))
			this.historyDataSource && await this.historyDataSource.changeVariables()
		}
		if (this.subscriptionDataSource) {
			this.subscriptionDataSource.setCallback(this.onSubscriptionData.bind(this))
			this.subscriptionDataSource.changeVariables()
		} else {
            widgetFrame.setupShowMoreButton()
        }
	}

	async onHistoryData(data, variables) {
		const array = this.config.topElement(data);
		if (Object.keys(array).length === 0) {
			this.wrapper.style.marginLeft = '15px'
			this.wrapper.textContent = 'No Data. Response is empty'
			return;
		}
		this.chainId = this.config.chainId(data);
		for (const row of array) {
			const cardElement = await this.createCardElement(row, variables);
			this.wrapper.appendChild(cardElement);
		}
	}

	async onSubscriptionData(data, variables) {
		const array = this.config.topElement(data);
		if (Object.keys(array).length === 0) {
			this.container.textContent = 'No Data. Response is empty'
			return;
		}
		this.chainId = this.config.chainId(data);
		const maxRows = 10;
		for (const row of array) {
			const cardElement = await this.createCardElement(row, variables);
			this.wrapper.insertBefore(cardElement, this.wrapper.firstChild);
			if (this.wrapper.childElementCount > maxRows) {
				this.wrapper.removeChild(this.wrapper.lastChild);
			}
		}
	}

	async createCardElement(rowData, variables) {
		const cardWrapper = this.createElementWithClasses('div', 'col', 'mb-4');
		const cardElement = this.createElementWithClasses('div', 'card');
		cardElement.style.minWidth = '417px'
		const row = this.createElementWithClasses('div', 'row', 'no-gutters');
		const [cardImg, cardTable] = await this.createCardSections(rowData, variables);
		this.appendChildren(cardWrapper, cardElement);
		this.appendChildren(cardElement, row);
		this.appendChildren(row, cardImg, cardTable);
		return cardWrapper;
	}

	async createCardSections(rowData, variables) {
		const cardImg = this.createElementWithClasses('div', 'col-4');

		for (const column of this.config.image) {
			if (column.rendering) {
				const imgElement = await column.rendering(column.cell(rowData), variables, this.chainId);
				if (column.cell(rowData).length < 1) {
					const uriError = 'error'
					const imgElement = await column.rendering(uriError, variables, this.chainId);
				}
				this.appendChildren(cardImg, imgElement);
			}
		}

		const cardTable = this.createElementWithClasses('div', 'col-8');
		const tableElement = this.createElementWithClasses('table', 'table', 'mb-0', 'table-sm', 'table-striped', 'table-hover');
		tableElement.style.tableLayout = 'fixed';
		cardTable.appendChild(tableElement);

		const tbody = this.createElementWithClasses('tbody');
		tableElement.appendChild(tbody);

		for (const column of this.config.columns) {
			const tr = this.createElementWithClasses('tr');
			const td1 = this.createElementWithClasses('td');
			const textCell1 = this.createElementWithClasses('span', 'text-info', 'font-weight-bold');
			textCell1.textContent = column.name;
			this.appendChildren(td1, textCell1);

			const td2 = this.createElementWithClasses('td');
			const textCell2 = this.createElementWithClasses('span');
			textCell2.textContent = column.cell(rowData);
			this.appendChildren(td2, textCell2);

			if (column.rendering) {
				const div = await column.rendering(column.cell(rowData), variables, this.chainId);
				td2.replaceChild(div, textCell2);
			}

			this.appendChildren(tr, td1, td2);
			this.appendChildren(tbody, tr);
		}

		return [cardImg, cardTable];
	}

	appendChildren(parent, ...children) {
		children.forEach(child => parent.appendChild(child));
	}
}