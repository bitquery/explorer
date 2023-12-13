 class GoogleChartsTableComponent {
	constructor(element, queryMetaInfo) {
		this.table = new google.visualization.Table(element);
		this.data = new google.visualization.DataTable();
		this.options = {
			allowHtml: true,
			showRowNumber: false,
			width: '100%',
			height: '100%',
			sortColumn: 0,
			sortAscending: false,
		};
		this.config = this.configuration();
		this.config.columns.forEach((column) => {
			this.data.addColumn(column.type ? column.type : 'string', column.name);
		});
		this.table.draw(this.data, this.options);
	}

	onData(data) {
		if (this.config.title && data) {
			 this.getTitle(data)
		}
		let array = this.config.topElement(data);
	const chainId =  this.config.chainId(data)

		let rows = [];
		array.forEach((rowData) => {
			let row = [];
			this.config.columns.forEach((column) => row.push(column.cell(rowData)));
			rows.push(row);
		});
		this.data.addRows(rows);
		this.table.draw(this.data, this.options);
	}
	 async getTitle(data) {
		 if (this.config && this.config.title && this.config.id) {

			 const divTitle = document.querySelector(`.\\#${this.config.id}`)
			 if (divTitle) {
				 const textNode = document.createTextNode(this.config.title(data))
				 divTitle.textContent = ''
				 divTitle.appendChild(textNode)
			 }
		 }
	 }
}