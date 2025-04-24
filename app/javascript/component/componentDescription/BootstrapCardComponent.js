export default class BootstrapCardComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.container = element;
		this.config = this.configuration();
		this.wrapper = this.createElementWithClasses('div', 'row', 'g-3');
		this.container.appendChild(this.wrapper);
		this.historyDataSource = historyDataSource;
		this.subscriptionDataSource = subscriptionDataSource;

		this.theme = this.config.theme || 'light';
		if (this.config.theme) {
			this.setTheme(this.config.theme);
		}
	}

	clearData() {
		this.wrapper.textContent = '';
	}

	createElementWithClasses(elementType, ...classes) {
		const element = document.createElement(elementType);
		element.classList.add(...classes);
		return element;
	}

	async init(widgetFrame) {
		if (this.historyDataSource) {
			this.historyDataSource.setCallback(this.onHistoryData.bind(this));
		}
		if (this.subscriptionDataSource) {
			this.subscriptionDataSource.setCallback(this.onSubscriptionData.bind(this));
		} else if (widgetFrame) {
			widgetFrame.setupShowMoreButton();
		}
	}

	async onHistoryData(data, variables) {
		if (this.config.title && data) {
			await this.getTitle(data);
		}

		const array = this.config.topElement(data);
		if (!array || array.length === 0) {
			this.container.textContent = 'No records found for this period. To get more data, please try selecting another date range. You can also use the Bitquery API by clicking the Get API button and experimenting with other datasets and time ranges to find the data you need.'
			return;
		}

		while (this.wrapper.firstChild) {
			this.wrapper.removeChild(this.wrapper.firstChild);
		}

		this.chainId = this.config.chainId(data);
		for (const row of array) {
			const cardElement = await this.createCardElement(row, variables);
			this.wrapper.appendChild(cardElement);
		}
	}

	async onSubscriptionData(data, variables) {
		const array = this.config.topElement(data);
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
		const cardElement = this.createElementWithClasses('div', 'card', 'h-100');
		cardElement.style.minWidth = '417px';
		cardElement.classList.add('shadow-sm');
		cardElement.style.borderRadius = '0.5rem';
		cardElement.style.overflow = 'hidden';
		cardElement.style.transition = 'transform 0.2s ease-in-out';
		cardElement.addEventListener('mouseover', () => {
			cardElement.style.transform = 'scale(1.02)';
		});
		cardElement.addEventListener('mouseout', () => {
			cardElement.style.transform = 'scale(1)';
		});

		const row = this.createElementWithClasses('div', 'row', 'g-0');

		const [cardImg, cardTable] = await this.createCardSections(rowData, variables);

		this.appendChildren(cardWrapper, cardElement);
		this.appendChildren(cardElement, row);
		this.appendChildren(row, cardImg, cardTable);
		return cardWrapper;
	}

	async createCardSections(rowData, variables) {
		const cardImg = this.createElementWithClasses('div', 'col-4');
		cardImg.style.padding = '0.5rem';
		for (const column of this.config.image) {
			if (column.rendering) {
				let cellValue = column.cell(rowData);
				if (!cellValue || cellValue.length < 1) {
					cellValue = 'error';
				}
				const imgElement = await column.rendering(cellValue, variables, this.chainId);
				this.appendChildren(cardImg, imgElement);
			}
		}

		const cardTable = this.createElementWithClasses('div', 'col-8');
		const cardBody = this.createElementWithClasses('div', 'card-body', 'p-2');
		cardTable.appendChild(cardBody);

		const tableElement = this.createElementWithClasses(
			'table',
			'table',
			'mb-0',
			'table-sm',
			'table-striped',
			'table-hover'
		);
		tableElement.style.tableLayout = 'fixed';
		if (this.theme === 'dark') {
			tableElement.classList.add('table-dark');
		}

		cardBody.appendChild(tableElement);
		const tbody = this.createElementWithClasses('tbody');
		tableElement.appendChild(tbody);

		for (const column of this.config.columns) {
			const tr = this.createElementWithClasses('tr');
			const td1 = this.createElementWithClasses('td');
			const textCell1 = this.createElementWithClasses('span', 'text-info', 'fw-bold');
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

	setTheme(theme) {
		this.theme = theme;
		const tables = this.container.querySelectorAll('.card table');
		tables.forEach(table => {
			if (theme === 'dark') {
				table.classList.add('table-dark');
			} else {
				table.classList.remove('table-dark');
			}
		});
	}

	async getTitle(data) {
		if (this.config && this.config.title && this.config.id) {
			const divTitle = document.querySelector(`.\\#${this.config.id}`);
			if (divTitle) {
				const textNode = document.createTextNode(this.config.title(data));
				divTitle.textContent = '';
				divTitle.appendChild(textNode);
			}
		}
	}

	appendChildren(parent, ...children) {
		children.forEach(child => parent.appendChild(child));
	}
}
