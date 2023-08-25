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
        if (!this.config.topElement(data) || Object.keys(this.config.topElement(data)).length === 0) {
            this.container.textContent = 'No Data. Response is empty'
            return;
        }
        const allData = this.config.topElement(data);
        this.chainId = this.config.chainId(data);

        function buildTree(evmData) {
            let tree = [];
            let calls = evmData.Calls;
            let events = evmData.Events;
            let lastNodes = {};

            calls.forEach(call => {
                if (call && call.Call) {
                    let nodeName = `Depth: ${call.Call.Depth} `;
                    let nodeText = `+++Index: ${call.Call.Index}  CallerIndex: ${call.Call.CallerIndex} ====EnterIndex: ${call.Call.EnterIndex}  ====ExitIndex: ${call.Call.ExitIndex}  Method: ${call.Call.Signature.Signature}        From:   ${call.Call.From} -> To:   ${call.Call.To}`
                    let EventForCall = events.filter(event => event.Log && event.Log.LogAfterCallIndex === call.Call.Index);
                    let children = EventForCall.map(event => {
                        return {
                            name: 'Event',
                            text: `+++Index: ${event.Log.Index} LogAfterCallIndex: ${event.Log.LogAfterCallIndex}   Event:   ${event.Log.Signature.Signature} ====EnterIndex: ${event.Log.EnterIndex}  ====ExitIndex: ${event.Log.ExitIndex}`,
                            children: []
                        };
                    });
                    let newNode = {
                        name: nodeName,
                        text: nodeText,
                        children: children || []
                    };
                    if (call.Call.Depth === 0) {
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

        function createTree(data, isRoot = false) {
            let ul = document.createElement('ul');
            ul.classList.add('ul-tree')
            ul.classList.add('resetcss-tree')
            if (isRoot) {
                ul.id = 'tree';
            }

            for (let item of data) {
                let li = document.createElement('li');
                li.classList.add('li-tree')

                let details = document.createElement('details');
                let summary = document.createElement('summary');
                summary.classList.add('summary-tree')
                summary.textContent = item.name;

                details.append(summary);

                let contentDiv = document.createElement('span');
                contentDiv.textContent = item.text;

                details.append(contentDiv);
                li.append(details);

                if (item.children && item.children.length > 0) {
                    let childUl = createTree(item.children);
                    details.append(childUl);
                // } else {
                //     summary.classList.add('no-children');
                }

                ul.append(li);
            }

            return ul;
        }

        let tree = createTree(dataTree, true);
        this.container.append(tree);

    }
}