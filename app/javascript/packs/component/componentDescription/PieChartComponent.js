export default class PieChartComponent {
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

			for (let i=0; i < dataArray.length; i++) {
				for (let j=0; j < this.config.columns.length; j++) {
					if (i === 0) {
						if ( dataToVizualize[i] ) {
							dataToVizualize[i].push( this.config.columns[j].name )
						} else {
							dataToVizualize.push( [this.config.columns[j].name] )
						}
					} else {
						if ( dataToVizualize[i] ) {
							dataToVizualize[i].push( this.config.columns[j].cell( dataArray[i] ) )
						} else {
							dataToVizualize.push([ this.config.columns[j].cell( dataArray[i] ) ])
						}
					}
				}
			}

			const dataTable = google.visualization.arrayToDataTable(dataToVizualize)
			const chart = new google.visualization.PieChart(this.wrapper)
			chart.draw(dataTable, this.config.options)
		}
		google.charts.load('current', {'packages':['corechart']});
		google.charts.setOnLoadCallback(drawChart);

	}

}
