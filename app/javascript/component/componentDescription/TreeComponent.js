export default class TreeComponent {
    constructor(element, historyDataSource ) {
        this.container = element;
        this.config = this.configuration();
        this.historyDataSource = historyDataSource;
    }

    async init() {
        this.historyDataSource.setCallback(this.onHistoryData.bind(this));
        await this.historyDataSource.changeVariables();
    }

    async onHistoryData(data) {
        this.container.style.scrollBehavior = 'smooth';
        const allData = this.config.topElement(data);
        if (!allData || Object.keys(allData).length === 0) {
            this.container.textContent = 'No Data. Response is empty';
            return;
        }

        const expandButton = document.createElement('button');
        expandButton.classList.add('btn', 'btn-outline-secondary', 'btn-sm', 'expand-button-tree')
        expandButton.textContent = '+';
        expandButton.addEventListener('click', this.expandAll.bind(this));

        const collapseButton = document.createElement('button');
        collapseButton.classList.add('btn', 'btn-outline-secondary', 'btn-sm', 'collapse-button-tree')
        collapseButton.textContent = '-';
        collapseButton.addEventListener('click', this.collapseAll.bind(this));
        this.chainId = this.config.chainId(data);
        const dataTree = this.buildTree(allData);
        const tree = this.createTree(dataTree, true);
        this.container.appendChild(expandButton);
        this.container.appendChild(collapseButton);

        this.container.append(tree);


        let lastScrollY = window.scrollY;
        window.addEventListener('scroll', () => {
            const containerRect = this.container.getBoundingClientRect();
            const collapseButton = this.container.querySelector('.collapse-button-tree');
            const containerTop = containerRect.top + window.scrollY + 25;
            const containerBottom = containerRect.bottom + window.scrollY - collapseButton.offsetHeight;
            const proposedPosition = window.scrollY + (window.innerHeight / 2);
            let newPosition = proposedPosition;

            if (newPosition < containerTop) {
                newPosition = containerTop;
            } else if (newPosition > containerBottom) {
                newPosition = containerBottom;
            }

            if (lastScrollY > window.scrollY) {
                if (newPosition < containerTop + 100) {
                    newPosition = containerTop + 100;
                }
            }
            lastScrollY = window.scrollY;
            if (collapseButton) {
                collapseButton.style.position = 'absolute';
                collapseButton.style.top = `${newPosition - containerTop}px`;
            }
        });

    }

    buildTree(evmData) {
        let tree = [];
        let lastParentNodes = {};

        evmData.Calls.forEach(call => {
            if (call && call.Call) {
                // const nodeText = `Depth:${call.Call.Depth} +++Index: ${call.Call.Index}  CallerIndex: ${call.Call.CallerIndex} ====EnterIndex: ${call.Call.EnterIndex}  ====ExitIndex: ${call.Call.ExitIndex} `;
                const newNode = {
                    // text: nodeText,
                    name: 'Call',
                    from: call.Call.From,
                    to: call.Call.To,
                    value: call.Call.Value,
                    method: call.Call.Signature.Signature,
                    methodHash: call.Call.Signature.SignatureHash,
                    returns: call.Returns,
                    callArguments: call.Arguments,
                    children: []
                };
                const parentArray = call.Call.Depth === 0 ? tree : lastParentNodes[call.Call.Depth - 1].children;
                parentArray.push(newNode);
                lastParentNodes[call.Call.Depth] = newNode;

                const eventForCall = evmData.Events
                    .sort((a, b) => a.Log.Index - b.Log.Index)
                    .filter(event => event.Log && event.Call.Index === call.Call.Index);

                eventForCall.forEach(event => {
                    // const eventNodeText = `Event:  ^^^^Call.Index: ${event.Call.Index}  +++Index: ${event.Log.Index} LogAfterCallIndex: ${event.Log.LogAfterCallIndex}   Event:   ${event.Log.Signature.Signature} ====EnterIndex: ${event.Log.EnterIndex}  ====ExitIndex: ${event.Log.ExitIndex}`;
                    const eventNode = {
                        // text: eventNodeText,
                        name: 'Event',
                        event: event.Log.Signature.Signature,
                        eventHash: event.Log.Signature.SignatureHash,
                        arguments: event.Arguments,
                        children: [],
                    };
                    parentArray.push(eventNode);
                });
            }
        });
        return tree;
    }

    createTree(data, isRoot = false) {
        const ul = document.createElement('ul');
        ul.className = 'ul-tree resetcss-tree';

        if (isRoot) {
            ul.id = 'tree';
        }

        data.forEach(item => {
            const li = document.createElement('li');
            li.className = 'li-tree';
            const details = document.createElement('details');
            details.addEventListener('toggle', () => {
                this.updateCollapseButton();
            });
            const summary = document.createElement('summary');
            summary.className = 'summary-tree';
            // summary.textContent = item.text;

            details.append(summary);
            li.append(details);
            const contentDiv = document.createElement('div');
            contentDiv.style.border ='2px solid red'

            if (item.name === "Call") {
                const callDiv = document.createElement('div');
                callDiv.classList.add('content-tree');
                const method = this.config.rendering.renderMethodLink({
                    method: item.method,
                    hash: item.methodHash
                }, null, this.chainId);
                const addressFrom = this.config.rendering.renderJustAddressLink(item.from, null, this.chainId);
                const addressTo = this.config.rendering.renderJustAddressLink(item.to, null, this.chainId);
                const renderSenderRecieverIcon = this.config.rendering.renderSenderRecieverIcon();
                const block1 = document.createElement('div')
                const block2 = document.createElement('div')
                const block3 = document.createElement('div')
                block1.classList.add('text-block')
                block1.appendChild(method);
                block2.appendChild(addressFrom);
                block3.appendChild(addressTo);
                callDiv.appendChild(block1)
                callDiv.appendChild(block2)
                callDiv.appendChild(renderSenderRecieverIcon);
                callDiv.appendChild(block3)
                let argumentsDiv = document.createElement('div')
                argumentsDiv.classList.add('event-tree')

                item.callArguments.forEach(element => {
                    if (element.Type === "address") {
                        const block = document.createElement('div')
                        block.classList.add('text-block')
                        let argName = document.createElement('span')
                        argName.classList.add('font-weight-bold')
                        let addressLink = this.config.rendering.renderJustAddressLink(element.Value.address, null, this.chainId)
                        argName.textContent = `${element.Name}:`

                        block.appendChild(argName)
                        block.appendChild(addressLink)
                        callDiv.appendChild(block)
                    }
                    if (element.Type.startsWith('uint') ) {
                        const block = document.createElement('div')
                        block.classList.add('text-block')
                        let argName = document.createElement('span')
                        argName.classList.add('font-weight-bold')
                        argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`
                        let addressNumber = this.config.rendering.renderNumbers(element.Value.bigInteger)
                        block.appendChild(argName)
                        block.appendChild(addressNumber)
                        callDiv.appendChild(block)
                    }
                    if (element.Type.startsWith('bytes')) {
                        const block = document.createElement('div')
                        block.classList.add('text-block')
                        let argName = document.createElement('span')
                        argName.classList.add('font-weight-bold')
                        argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`

                        let valueBytes =  this.config.rendering.renderBytes32(element.Value.hex)
                        console.log(valueBytes)
                        block.appendChild(argName)
                        block.appendChild(valueBytes)
                        callDiv.appendChild(block)

                    }


                })
                if(item.returns.length >0){
                    const returnContent = document.createElement('div')
                    returnContent.classList.add('d-flex')
                    returnContent.style.gap = '0 6px'
                    const returnContentText = document.createElement('div')
                    returnContent.classList.add('font-weight-bold')
                    returnContent.textContent = 'Return:'
                    item.returns.forEach(element => {
                        if (element.Type === "address") {
                            const block = document.createElement('div')
                            block.classList.add('text-block')
                            block.style.background = 'red'
                            let argName = document.createElement('span')
                            argName.classList.add('font-weight-bold')
                            let addressLink = this.config.rendering.renderJustAddressLink(element.Value.address, null, this.chainId)
                            argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`

                            block.appendChild(argName)
                            block.appendChild(addressLink)
                            returnContent.appendChild(block)
                        }
                        if (element.Type.startsWith('uint')) {
                            const block = document.createElement('div')
                            block.classList.add('text-block')
                            block.style.background = 'red'

                            let argName = document.createElement('span')
                            argName.classList.add('font-weight-bold')
                            argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`
                            let addressNumber = this.config.rendering.renderNumbers(element.Value.bigInteger)
                            block.appendChild(argName)
                            block.appendChild(addressNumber)
                            returnContent.appendChild(block)
                        }
                        if (element.Type.startsWith('bytes')) {
                            const block = document.createElement('div')
                            block.classList.add('text-block')
                            block.style.background = 'red'

                            let argName = document.createElement('span')
                            argName.classList.add('font-weight-bold')
                            argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`
                            let valueBytes = this.config.rendering.renderBytes32(element.Value.hex)
                            block.appendChild(argName)
                            block.appendChild(valueBytes)
                            returnContent.appendChild(block)
                        }
                        if (element.Type === "bool") {
                            const block = document.createElement('div')
                            block.classList.add('text-block')
                            block.style.background = 'red'

                            let argName = document.createElement('span')
                            argName.classList.add('font-weight-bold')
                            argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`
                            let valueBytes = document.createElement('span')
                            valueBytes.textContent = element.Value.bool
                            block.appendChild(argName)
                            block.appendChild(valueBytes)
                            returnContent.appendChild(block)
                        }
                    })
                    callDiv.appendChild(returnContent)
                }
                // callDiv.appendChild(argumentsDiv);
                contentDiv.appendChild(callDiv);

            }
            if (item.name === 'Event') {
                let argumentsDiv = document.createElement('div')
                argumentsDiv.style.background ='lightgreen'

                argumentsDiv.classList.add('d-flex', 'flex-wrap', 'event-tree')
                const block = document.createElement('div')
                block.classList.add('text-block')

                item.arguments.forEach(element => {
                    if (element.Type === "address") {
                        const block = document.createElement('div')
                        block.classList.add('text-block')
                        let argName = document.createElement('div')
                        let addressLink = this.config.rendering.renderJustAddressLink(element.Value.address, null, this.chainId)
                        argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`

                        argName.classList.add('font-weight-bold')
                        block.appendChild(argName)
                        block.appendChild(addressLink)
                        argumentsDiv.appendChild(block)

                    }
                    if (element.Type.startsWith('uint')) {
                        const block = document.createElement('div')
                        block.classList.add('text-block')
                        let argName = document.createElement('div')
                        argName.classList.add('font-weight-bold')

                        argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`

                        let addressNumber = this.config.rendering.renderNumbers(element.Value.bigInteger)
                        block.appendChild(argName)
                        block.appendChild(addressNumber)
                        argumentsDiv.appendChild(block)
                    }
                    if (element.Type.startsWith('bytes')) {
                        const block = document.createElement('div')
                        block.classList.add('text-block')
                        let argName = document.createElement('div')
                        argName.classList.add('font-weight-bold')

                        argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`

                        let valueBytes = this.config.rendering.renderBytes32(element.Value.hex)
                        block.appendChild(argName)
                        block.appendChild(valueBytes)
                        argumentsDiv.appendChild(block)
                    }
                })
                contentDiv.appendChild(argumentsDiv);
            }
            if (item.children && item.children.length > 0) {
                const childUl = this.createTree(item.children);
                details.append(childUl);
            } else {
                summary.classList.add('no-children');
            }
            summary.appendChild(contentDiv)
            ul.append(li);
        });

        return ul;
    }

    expandAll() {
        const detailsElements = this.container.querySelectorAll('details');
        detailsElements.forEach((details) => {
            details.open = true;
        });
        const collapseButton = this.container.querySelector('.collapse-button-tree');
        if (collapseButton) collapseButton.style.display = 'block';
    }

    collapseAll() {
        const detailsElements = this.container.querySelectorAll('details');
        detailsElements.forEach((details) => {
            details.open = false;
        });
        const collapseButton = this.container.querySelector('.collapse-button-tree');
        if (collapseButton) collapseButton.style.display = 'none';
    }

    updateCollapseButton() {
        const detailsElements = this.container.querySelectorAll('details');
        const isOpen = Array.from(detailsElements).some(details => details.open);
        const collapseButton = this.container.querySelector('.collapse-button-tree');
        if (collapseButton) {
            collapseButton.style.display = isOpen ? 'block' : 'none';
        }
    }


}
