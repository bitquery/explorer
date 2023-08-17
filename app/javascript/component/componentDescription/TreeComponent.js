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
        console.log(data)
        if (!this.config.topElement(data) || Object.keys(this.config.topElement(data)).length === 0) {
            this.container.textContent = 'No Data. Response is empty'
            return;
        }
        const allData = this.config.topElement(data);
        this.chainId = this.config.chainId(data);

        function buildTree(evmData) {
            let tree = [];
            let calls = evmData.Calls;
            let logs = evmData.Events;
            let lastNodes = {};

            calls.forEach(call => {
                if (call && call.Call) {
                    let nodeName = `Depth: ${call.Call.Depth}  CallerIndex: ${call.Call.CallerIndex}  Method: ${call.Call.Signature.Signature}        From:   ${call.Call.From} -> To:   ${call.Call.To}`;
                    let logForCall = logs.filter(log => log.Log && log.Log.LogAfterCallIndex === call.Call.Index);
                    let children = logForCall.map(log => {
                        return {
                            name: `LogAfterCallIndex: ${log.Log.LogAfterCallIndex}   Event:   ${log.Log.Signature.Signature}`,
                            children: []
                        };
                    });
                    let newNode = {
                        name: nodeName,
                        children: children
                    };
                    if (call.Call.Depth === 1) {
                        tree.push(newNode);
                    } else {
                        let parentDepth = call.Call.Depth - 1;
                        if (lastNodes[parentDepth]) {
                            lastNodes[parentDepth].children.push(newNode);
                        }
                    }
                    lastNodes[call.Call.Depth] = newNode;
                }
            });
            return tree;
        }

        const dataTree = buildTree(allData);
        console.log(dataTree);
        const tree = new TreeView(dataTree, this.container);
    }
}
