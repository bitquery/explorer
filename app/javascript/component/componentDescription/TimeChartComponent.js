export default class TimeChartComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.container = element
		this.config = this.configuration()
		this.historyDataSource = historyDataSource
		this.subscriptionDataSource = subscriptionDataSource
	}

	async init() {
		if (this.historyDataSource) {
			this.historyDataSource.setCallback(this.onHistoryData.bind(this))
		}
		if (this.subscriptionDataSource) {
			this.subscriptionDataSource.setCallback(this.onSubscriptionData.bind(this))
		}
	}

	async onHistoryData(data) {
		if (this.config.title && data) {
			await this.getTitle(data)
		}
		const parentTextColor = window.getComputedStyle(this.container.parentElement, null).getPropertyValue('color');
		const darkTheme = {
			titleTextStyle: { color: parentTextColor },
			backgroundColor:  'transparent',
			hAxis: {
				textStyle : { color: parentTextColor },
				titleTextStyle: { color: parentTextColor },
			},
			vAxis: {
				textStyle : { color: parentTextColor },
				titleTextStyle: { color: parentTextColor },
				...(this.config.options.vAxis && this.config.options.vAxis.minValue !== undefined && { minValue: this.config.options.vAxis.minValue })
			},
			legend: {
				textStyle: { color: parentTextColor }
			},
		};
		this.config.options = {...darkTheme,...this.config.options}

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
