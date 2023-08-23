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
                    let nodeName = `Depth: ${call.Call.Depth} +++Index: ${call.Call.Index}  CallerIndex: ${call.Call.CallerIndex} ====EnterIndex: ${call.Call.EnterIndex}  ====ExitIndex: ${call.Call.ExitIndex}  Method: ${call.Call.Signature.Signature}        From:   ${call.Call.From} -> To:   ${call.Call.To}`;
                    let EventForCall = events.filter(event => event.Log && event.Log.LogAfterCallIndex === call.Call.Index);
                    let children = EventForCall.map(event => {
                        return {
                            name: `+++Index: ${event.Log.Index} LogAfterCallIndex: ${event.Log.LogAfterCallIndex}   Event:   ${event.Log.Signature.Signature} ====EnterIndex: ${event.Log.EnterIndex}  ====ExitIndex: ${event.Log.ExitIndex}`,
                            children: []
                        };
                    });
                    let newNode = {
                        name: nodeName,
                        children: children || []
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
            console.log(tree)
            return tree;
        }

        const dataTree = buildTree(allData);
        dataTree
        console.log(dataTree);

        // const tree = new TreeView(dataTree, this.container);
        function createTree(data) {
            let ul = document.createElement('ul');
            for (let item of data) {
                let li = document.createElement('li');
                li.textContent = item.name;
                if (item.children && item.children.length) {
                    li.append(createTree(item.children));
                }
                ul.append(li);
            }
            return ul;
        }

        let tree = createTree(dataTree);
        this.container.append(tree);

        for (let i of tree.querySelectorAll('li')) {
            let span = document.createElement('span');
            span.classList.add('show-tree');
            i.prepend(span);
            span.append(span.nextSibling);
        }

        tree.onclick = event => {
            if (event.target.tagName != 'SPAN') return;
            let childrenContainer = event.target.parentNode.querySelector('ul');
            if (!childrenContainer) return;
            childrenContainer.hidden = !childrenContainer.hidden;
            if (childrenContainer.hidden) {
                event.target.classList.add('hide-tree');
                event.target.classList.remove('show-tree');
            } else {
                event.target.classList.add('show-tree');
                event.target.classList.remove('hide-tree');
            }
        };

    }
}