export default class TreeComponent {
    constructor(element, historyDataSource, subscriptionDataSource) {
        this.container = element;
        this.config = this.configuration();
        this.historyDataSource = historyDataSource;
        this.subscriptionDataSource = subscriptionDataSource;
    }

    async init() {
        if (this.historyDataSource) {
            this.historyDataSource.setCallback(this.onHistoryData.bind(this));
            await this.historyDataSource.changeVariables();
        }
        if (this.subscriptionDataSource) {
            this.subscriptionDataSource.setCallback(this.onSubscriptionData.bind(this));
            this.subscriptionDataSource.changeVariables();
        }
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
                    value:call.Call.Value,
                    method: call.Call.Signature.Signature,
                    methodHash: call.Call.Signature.SignatureHash,
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
                        // value: event.Arguments[2].Value.bigInteger,
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
            if (item.name === "Call") {
                console.log(item)

                const callDiv = document.createElement('div');
                const method = this.config.rendering.renderMethodLink({
                    method: item.method,
                    hash: item.methodHash
                }, null, this.chainId);
                const addressFrom = this.config.rendering.renderJustAddressLink(item.from, null, this.chainId);
                const addressTo = this.config.rendering.renderJustAddressLink(item.to, null, this.chainId);
                const renderSenderRecieverIcon = this.config.rendering.renderSenderRecieverIcon();

                callDiv.classList.add('content-tree');
                callDiv.appendChild(method);
                // callDiv.insertAdjacentHTML('beforeend', '<strong>From:  </strong> ');
                callDiv.appendChild(addressFrom);
                callDiv.appendChild(renderSenderRecieverIcon);
                // callDiv.insertAdjacentHTML('beforeend', '<strong>To:  </strong> ');
                callDiv.appendChild(addressTo);

                contentDiv.appendChild(callDiv);
            }
            if (item.name === 'Event') {
                let eventDiv = document.createElement('div');
                eventDiv.style.border ='2px solid red'

                // const eventValue= this.config.rendering.renderNumbers(item.value)
                let argumentsDiv = document.createElement('div')
                argumentsDiv.classList.add('d-flex','flex-wrap','event-tree')
                argumentsDiv.style.gap = '10px'
                item.arguments.forEach(element =>{

                    if(element.Type === "address"){
                        let argName = document.createElement('div')
                        let addressLink = this.config.rendering.renderJustAddressLink(element.Value.address,null, this.chainId)
                        argName.textContent = `${element.Name}:`
                        argumentsDiv.appendChild(argName)
                        argumentsDiv.appendChild(addressLink)
                    }
                    if(element.Type === "uint256"){
                        let argName = document.createElement('div')

                        argName.textContent = `${element.Name}:`

                        let addressNumber = this.config.rendering.renderNumbers(element.Value.bigInteger)
                        argumentsDiv.appendChild(argName)
                        argumentsDiv.appendChild(addressNumber)
                    }
                    if(element.Type === "bytes32"){
                        let argName = document.createElement('div')
                        argName.textContent = `${element.Name}:`
                        let valueBytes = this.config.rendering.renderBytes32(element.Value.hex)
                        argumentsDiv.appendChild(argName)
                        argumentsDiv.appendChild(valueBytes)
                    }
                })
                // eventDiv.classList.add('event-tree');
                // eventDiv.insertAdjacentHTML('beforeend', '<strong>Event:</strong> ');
                // const eventLink = this.config.rendering.renderEventLink({
                //     event: item.event,
                //     hash: item.eventHash
                // }, null, this.chainId);
                // eventDiv.appendChild(eventLink);
                // eventDiv.appendChild(argumentsDiv);
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
