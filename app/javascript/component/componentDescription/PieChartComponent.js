export default class PieChartComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.container = element
		this.config = this.configuration()
		this.historyDataSource = historyDataSource
		this.subscriptionDataSource = subscriptionDataSource
	}

	async init() {
		if (this.historyDataSource) {
			this.historyDataSource.setCallback(this.onHistoryData.bind(this))
			this.historyDataSource && await this.historyDataSource.changeVariables()
		}
		if (this.subscriptionDataSource) {
			this.subscriptionDataSource.setCallback(this.onSubscriptionData.bind(this))
			this.subscriptionDataSource.changeVariables()
		}
	}

	async onHistoryData(data) {
		const drawChart = () => {
			const dataArray = this.config.topElement(data)
			if (!dataArray || Object.keys(dataArray).length === 0) {
				this.container.textContent = 'No Data. Response is empty'
				return;
			}
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

		window.addEventListener('resize', () => {
			this.container.removeChild(this.container.firstChild)
			drawChart()
		})
	}
}
