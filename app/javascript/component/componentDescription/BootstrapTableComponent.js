export default class BootstrapTableComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.container = element;
		this.historyDataSource = historyDataSource
		this.subscriptionDataSource = subscriptionDataSource
		this.config = this.configuration();
		this.createWrapper();
		this.createTable();
	}
	clearData() {
		this.tbody.textContent = ''
	}
	createWrapper() {
		this.wrapper = this.createElementWithClasses('div', 'table-responsive-md');
		this.container.appendChild(this.wrapper);
	}

	createTable() {
		this.tableElement = this.createElementWithClasses('table', 'table', 'table-sm', 'table-striped', 'table-hover');
		this.tableElement.style.tableLayout = 'fixed';
		this.wrapper.appendChild(this.tableElement)
		this.createThead();
		this.createTbody();
		this.createTfooter();
	}

	createThead() {
		const thead = this.createElementWithClasses('thead');
		const tr = this.createElementWithClasses('tr');
		this.tableElement.appendChild(thead)
		thead.appendChild(tr)

		this.config.columns.forEach(({ name }) => {
			const th = this.createElementWithClasses('th');
			th.setAttribute('scope', 'row');
			th.textContent = name;
			tr.appendChild(th)
		});
	}

	createTbody() {
		this.tbody = this.createElementWithClasses('tbody');
		this.tableElement.appendChild(this.tbody)
	}

	createTfooter() {
		const tfooter = this.createElementWithClasses('div');
		this.tableElement.appendChild(tfooter)
	}

	async init() {
		this.historyDataSource.setCallback( this.onHistoryData.bind(this) )
		this.subscriptionDataSource.setCallback( this.onSubscriptionData.bind(this) )
		await this.historyDataSource.changeVariables()
		this.subscriptionDataSource.changeVariables()
	}
	
	async onHistoryData(data, variables) {
		const rows = await this.composeRows(data, variables)
		this.appendChildren(this.tbody, rows);
	}

	async onSubscriptionData(data, variables) {
		const maxRows = 15;
		const rows = await this.composeRows(data, variables)
		rows.forEach(tr => {
			this.tbody.insertBefore(tr, this.tbody.firstChild)
			if (this.tbody.childElementCount > maxRows) {
			  this.tbody.removeChild(this.tbody.lastChild);
			}
		})
	}

	async composeRows(rawData, variables) {
		const data = this.config.topElement(rawData);
		let chainId = ''
		if (data.length > 0) {
			chainId = this.config.chainId(rawData)
		}
		const rows = []
		for (const row of data) {
			const tr = this.createElementWithClasses('tr');

			for (const column of this.config.columns) {
				const td = this.createElementWithClasses('td');
				const textCell = this.createElementWithClasses('span');
				textCell.textContent = column.cell(row);
				td.appendChild(textCell)

				if (column.rendering) {
					const div = await column.rendering(column.cell(row), variables, chainId);

					td.replaceChild(div, textCell);
				}

				tr.appendChild(td);
				rows.push(tr)
			}
		}
		return rows
	}

	createElementWithClasses(elementType, ...classes) {
		const element = document.createElement(elementType);
		element.classList.add(...classes);
		return element;
	}

	appendChildren(parent, children) {
		children.forEach(child => {
			console.log(child)
			parent.appendChild(child)});
	}
}