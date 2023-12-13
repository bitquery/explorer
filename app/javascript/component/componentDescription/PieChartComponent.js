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
            backgroundColor: 'transparent',
            titleTextStyle: {color: parentTextColor},
            pieSliceTextStyle: {color: parentTextColor},
            legend: {textStyle: {color: parentTextColor}}
        };
        this.config.options = {...this.config.options, ...darkTheme}

        const drawChart = () => {
            const dataArray = this.config.topElement(data)
            let dataToVizualize = []
            let annotation = []
            for (let i = 0; i < dataArray.length; i++) {
                for (let column of this.config.columns) {
                    if (i === 0) {
                        annotation.push(column.name)
                    }
                    if (dataToVizualize[i]) {
                        dataToVizualize[i].push(column.cell(dataArray[i]))
                    } else {
                        dataToVizualize.push([column.cell(dataArray[i])])
                    }
                }
            }
            dataToVizualize.unshift(annotation)
            const dataTable = google.visualization.arrayToDataTable(dataToVizualize)
            const chart = new google.visualization.PieChart(this.container)
            chart.draw(dataTable, this.config.options)
        }
        google.charts.load('current', {'packages': ['corechart']});
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
