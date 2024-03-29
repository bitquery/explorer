export default class BaseComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.container = element;
		this.config = this.configuration();
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
}
