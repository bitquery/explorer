export default class TimeChartComponent {
	constructor(element, variables) {
		this.container = element
		this.config = this.configuration()
		this.variables = variables
	}

	async onData(data, sub) {
		const drawChart = () => {
			const dataArray = this.config.topElement(data)
			let dataToVizualize = []
			let annotation = []
			let k = 0
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
					if (k>0 && columnName === 'Date' && dataToVizualize[k-1] && el === dataToVizualize[k-1][0]) {
						k--
					}
					if (!dataToVizualize[k]) {
						dataToVizualize.push([])
					}
					dataToVizualize[k][currentIndex] = el
				}
				k++
			}
			dataToVizualize = dataToVizualize.map(row => {
				if (!row[annotation.length-1]) {
					row[annotation.length-1] = 0
				}
				return row
			})
			dataToVizualize.unshift(annotation)

			const dataTable = google.visualization.arrayToDataTable(dataToVizualize)
			const chart = new google.visualization.ColumnChart(this.container)
			chart.draw(dataTable, this.config.options)
		}
		google.charts.load('current', {packages: ['corechart', 'bar']});
		google.charts.setOnLoadCallback(drawChart);
		
		window.addEventListener('resize', () => {
			this.container.removeChild(this.container.firstChild)
			drawChart()
		})
	}
}
