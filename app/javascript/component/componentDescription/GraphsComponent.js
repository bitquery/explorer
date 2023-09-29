export default class GraphsComponent {
    constructor(element, historyDataSource, subscriptionDataSource) {
        this.container = element;
        this.config = this.configuration();
        this.historyDataSource = historyDataSource;
        this.subscriptionDataSource = subscriptionDataSource;
        this.data2 = {
            nodes: [],
            edges: []
        };
        this.network = null;
    }

    shortenText(text, maxCharCount = 10) {
        return text.length > maxCharCount ? `${text.substr(0, maxCharCount)}...` : text;
    }

    async init() {

        if (this.historyDataSource) {
            this.historyDataSource.setCallback(this.onHistoryData.bind(this))
        }
        if (this.subscriptionDataSource) {
            this.subscriptionDataSource.setCallback(this.onSubscriptionData.bind(this))
        }
        if (document.getElementById("fromToCheckbox")) {
            document.getElementById("fromToCheckbox").addEventListener("change", () => this.updateGraph());
            document.getElementById("moneyFlowCheckbox").addEventListener("change", () => this.updateGraph());

        }

    }

    async onHistoryData(data) {
        if (!data || Object.keys(data).length === 0) {
            this.container.textContent = 'No Data. Response is empty';
            return;
        }
        if(data.EVM && data.EVM.Transfers.length <1){
            document.getElementById("DisplayFromToCheckbox").style.display = 'none'
            document.getElementById("DisplayMoneyFlowCheckbox").style.display = 'none'
            this.container.textContent = 'No Data. Response is empty';
            return;
        }
        const array = this.config.topElement(data);
        const chainId = this.config.chainId(data);
        let nodes = [];
        let edges = [];
        const addresses = new Set();
        let linkReady = false
        for (const rowData of array) {
            let dataObject = {};
            for (const column of this.config.columns) {
                const cellData = column.cell(rowData);
                if (column.name === 'Sender' || column.name === 'Receiver') {
                    dataObject[column.name] = cellData;
                    if (!addresses.has(cellData)) {
                        addresses.add(cellData);
                        nodes.push({
                            id: cellData,
                            label: this.shortenText(cellData),
                            url: `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/address/${dataObject[column.name]}`,
                        });
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
                    linkReady = true
                }
                if (column.name === 'Currency') {
                    dataObject[column.name] = cellData;
                }
                if (column.name === 'Value') {
                    if (column.rendering) {
                        dataObject[column.name] = await column.rendering(column.cell(rowData)).textContent;
                    }
                }
            }

            edges.push({
                from: dataObject['Sender'],
                to: dataObject['Receiver'],
                label: dataObject['Time'],
                url:  `https://explorer.bitquery.io/${WidgetConfig.getNetwork(chainId)}/tx/${dataObject['TX Hash']}` ,
                type: "from-to",
                value: null,

                font: {
                    align: 'middle'
                },
                smooth: {
                    type: 'dynamic'
                }
            });

            if (dataObject['Value']) {
                edges.push({
                    from: dataObject['Sender'],
                    to: dataObject['Receiver'],
                    label: `${dataObject['Value']} ${dataObject['Currency']}`,
                    type: "money-flow",
                    value: dataObject['Value'],
                    color: {
                        color: '#00ff00',
                        highlight: '#00ff00',
                        hover: '#00ff00',
                        inherit: false,
                        opacity: 1.0
                    },
                    font: {
                        align: 'middle'
                    },
                    smooth: {
                        type: 'dynamic'
                    }
                });
            }
        }

        this.data2 = {
            nodes: nodes,
            edges: edges,
        };

        const network = new vis.Network(this.container, this.data2, this.getOptions());
        this.network = network

        if (linkReady === true) {
            network.on('click', function (properties) {
                const nodeId = properties.nodes[0];
                const edgeId = properties.edges[0];

                if (nodeId) {
                    const node = this.data2.nodes.find(node => node.id === nodeId);
                    if (node && node.url) {
                        window.open(node.url, '_blank');
                    }
                } else if (edgeId) {
                    const edge = this.data2.edges.find(edge => edge.id === edgeId);
                    if (edge && edge.url) {
                        window.open(edge.url, '_blank');
                    }
                }
            }.bind(this));
        }
    }

    updateGraph() {
        if (!this.data2 || !this.data2.edges) return
        const fromToCheckbox = document.getElementById("fromToCheckbox").checked;
        const moneyFlowCheckbox = document.getElementById("moneyFlowCheckbox").checked;

        let filteredEdges = [];

        if (fromToCheckbox) {
            filteredEdges = [...filteredEdges, ...this.data2.edges.filter(edge => edge.type === "from-to")];
        }

        if (moneyFlowCheckbox) {
            filteredEdges = [...filteredEdges, ...this.data2.edges.filter(edge => edge.type === "money-flow")];
        }

        const updatedData = {
            nodes: this.data2.nodes,
            edges: filteredEdges
        };
        this.network.setData(updatedData);
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
                    centralGravity: 0.05,
                    springLength: 95,
                    springConstant: 0.01,
                },
            }
        };
    }
}
