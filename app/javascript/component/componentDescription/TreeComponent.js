export default class TreeComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.container = element;
		this.config = this.configuration();
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
		const allData = this.config.topElement(data);
		this.chainId = this.config.chainId(data);

		// var tree = new TreeView(
		// 	[
		// 		{ name: 'Item 1', children: [] },
		// 		{
		// 			name: 'Item 2',
		// 			expanded: true,
		// 			children: [
		// 				{ name: 'Sub Item 1', children: [] },
		// 				{ name: 'Sub Item 2', children: [] },
		// 			],
		// 		},
		// 	],
		// 	this.container
		// );
		// tree.on('select', function (e) {
		// 	console.log(JSON.stringify(e));
		// });
		//
		// allData.Calls.forEach(e => {
		//
		// })

	}
}
