export default class PieChartComponent {
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
			for (let i=0; i < dataArray.length; i++) {
				for (let column of this.config.columns) {
					if (i === 0) {
						annotation.push( column.name )
					} 
					if ( dataToVizualize[i] ) {
						dataToVizualize[i].push( column.cell( dataArray[i] ) )
					} else {
						dataToVizualize.push([ column.cell( dataArray[i] ) ])
					}
				}
			}
			dataToVizualize.unshift( annotation )
			const dataTable = google.visualization.arrayToDataTable(dataToVizualize)
			const chart = new google.visualization.PieChart(this.container)
			chart.draw(dataTable, this.config.options)
		}
		google.charts.load('current', {'packages':['corechart']});
		google.charts.setOnLoadCallback(drawChart);

	}
}
