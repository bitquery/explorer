export default class GraphsComponent {
	constructor(element, historyDataSource, subscriptionDataSource) {
		this.container = element;
		this.config = this.configuration();
		this.historyDataSource = historyDataSource
		this.subscriptionDataSource = subscriptionDataSource
	}

	shortenText(text, maxCharCount = 10) {
		return text.length > maxCharCount ? `${text.substr(0, maxCharCount)}...` : text;
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
		const array = this.config.topElement(data);
		const chainId = this.config.chainId(data)
		let nodes = [];
		let edges = [];
		const addresses = new Set();
		for (const rowData of array) {
			let dataObject = {};
			for (const column of this.config.columns) {
				const cellData = column.cell(rowData);
				if (column.name === 'Sender' || column.name === 'Receiver') {
					dataObject[column.name] = cellData;
					if (!addresses.has(cellData)) {
						addresses.add(cellData);
						if (column.name === 'Sender') {
							nodes.push({
								id: cellData,
								label: this.shortenText(cellData),
								url: `/${WidgetConfig.getNetwork(chainId)}/address/${dataObject['Sender']}/nft_address`,
							});
						}
						if (column.name === 'Receiver') {
							nodes.push({
								id: cellData,
								label: this.shortenText(cellData),
								url: `/${WidgetConfig.getNetwork(chainId)}/address/${dataObject['Receiver']}/nft_address`,
							});
						}
					}
				}
				if (column.name === 'Time') {
					dataObject[column.name] = cellData;
					if (column.rendering) {
						dataObject[column.name] = await column.rendering(column.cell(rowData)).textContent;
					}
				}
				if (column.name === 'TX Hash') {
					dataObject[column.name] = cellData;
					dataObject[column.name] = column.cell(rowData);
				}
			}
			edges.push({
				from: dataObject['Sender'],
				to: dataObject['Receiver'],
				label: dataObject['Time'],
				url: `/${WidgetConfig.getNetwork(chainId)}/tx/${dataObject['TX Hash']}`,
			});
		}

		const data2 = {
			nodes: nodes,
			edges: edges,
		};

		const network = new vis.Network(this.container, data2, this.getOptions());

		network.on('click', function (properties) {
			const nodeId = properties.nodes[0];
			const edgeId = properties.edges[0];

			if (nodeId) {
				const node = data2.nodes.find(node => node.id === nodeId);
				if (node && node.url) {
					window.open(node.url, '_blank');
				}
			} else if (edgeId) {
				const edge = data2.edges.find(edge => edge.id === edgeId);
				if (edge && edge.url) {
					window.open(edge.url, '_blank');
				}
			}
		});
	}

	getOptions() {
		return {
			autoResize: true,
			height: '500px',
			width: '100%',
			edges: {
				arrows: 'to',
			},
			physics: {
				barnesHut: {
					gravitationalConstant: -4000,
					centralGravity: 0.1,
					springLength: 95,
					springConstant: 0.01,
				},
			},
		};
	}
}
