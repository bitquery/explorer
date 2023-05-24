export default class TimeChartComponent {
	constructor(element, variables) {
		this.container = element
		this.config = this.configuration()
		this.variables = variables
		this.createWrapper()
	}

	createWrapper() {
		this.wrapper = document.createElement("div")
		this.wrapper.classList.add("table-responsive-md")
		this.container.appendChild(this.wrapper)
	}

	async onData(data, sub) {
		const drawChart = () => {
			const dataArray = this.config.topElement(data)
			let dataToVizualize = []
			let annotation = []
			for (let i = 0; i < dataArray.length; i++) {
				for (let column of this.config.columns) {
					const columnName = typeof column.name === 'function' ? column.name(dataArray[i]) : column.name
					const nameIndex = annotation.findIndex(el => el === columnName)
					let currentIndex = nameIndex
					const el = column.cell(dataArray[i])
					if (nameIndex === -1) {
						currentIndex = annotation.length
						annotation.push(columnName)
					}
					if (!dataToVizualize[i]) {
						dataToVizualize.push([])
					}
					dataToVizualize[i][currentIndex] = el
				}
			}
			dataToVizualize = dataToVizualize.map(row => {
				if (!row[annotation.length-1]) {
					row[annotation.length-1] = 0
				}
				return row
			})
			dataToVizualize.unshift(annotation)

			const dataTable = google.visualization.arrayToDataTable(dataToVizualize)
			const chart = new google.charts.Bar(this.wrapper)
			chart.draw(dataTable, google.charts.Bar.convertOptions(this.config.options))
		}
		google.charts.load('current', { 'packages': ['bar'] });
		google.charts.setOnLoadCallback(drawChart);

	}
}
