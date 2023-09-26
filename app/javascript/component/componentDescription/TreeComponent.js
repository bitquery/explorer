export default class TreeComponent {
    constructor(element, historyDataSource) {
        this.container = element;
        this.config = this.configuration();
        this.historyDataSource = historyDataSource;
    }

    async init() {
        this.historyDataSource.setCallback(this.onHistoryData.bind(this));
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
                const newNode = {
                    name: 'Call',
                    call: call.Call,
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
                    const eventNode = {
                        name: 'Event',
                        event: event.Log,
                        eventArguments: event.Arguments,
                        children: [],
                    };
                    parentArray.push(eventNode);
                });
            }
        });
        return tree;
    }

    createTree(data, isRoot = false, counter = 0) {
        const ul = this.createElementWithClasses('ul', 'ul-tree')

        if (isRoot) ul.id = 'tree';
        console.log('data.', data)

        data.forEach(item => {
            counter++
            const li = this.createElementWithClasses('li', 'li-tree')
            const details = this.createElementWithClasses('details')

            details.addEventListener('toggle', () => {
                this.updateCollapseButton();
            });
            const summary = this.createElementWithClasses('summary', 'summary-tree', 'card', 'mb-1')
            this.appendChildren(details, summary)
            this.appendChildren(li, details)

            const contentDiv = this.createElementWithClasses('div')
            const openingDiv = this.createElementWithClasses('span')
            openingDiv.textContent = '('
            const closingDiv = this.createElementWithClasses('span')
            closingDiv.textContent = ')'
            const pathName = this.createElementWithClasses('span', 'name-tree')
            if (item.name === "Call") {
                const callDiv = this.createElementWithClasses('div', 'content-tree')
                if (counter % 2 !== 0) {
                    callDiv.style.boxShadow = 'inset 0 0 0 1000px rgba(0, 0, 0, 0.03)'
                }
                const iconElement = this.createIcon('fa-share', 'text-primary')

                const method = document.createElement('div');
                method.textContent = item.call.Signature.Name.length > 1 ? item.call.Signature.Name : item.call.Signature.SignatureHash
                if (item.call.Signature.SignatureHash === '') method.textContent = 'transfer of money'
                const gas = this.createElementWithClasses('div')
                gas.textContent = `Gas: ${item.call.Gas}`
                const gasUsed = this.createElementWithClasses('div')
                gasUsed.textContent = `Gas used: ${item.call.GasUsed}`

                this.appendChildren(callDiv, iconElement, method, gas, gasUsed)
                const argumentsDiv = this.createElementWithClasses('div', 'event-tree')
                const callArgumentsDiv = this.createElementWithClasses('div', 'content-tree')
                const callArgumentsPathDiv = this.createElementWithClasses('div', 'content-tree')
                item.callArguments.forEach(element => {
                    const block = this.createElementWithClasses('div', 'text-block', 'ml-2')
                    const argName = this.createElementWithClasses('span', 'name-tree')

                    if (element.Path.length > 0) {

                        pathName.textContent = `${element.Path[0].Name}:`

                        element.Path.forEach(item => {
                            console.log('item.Name', item.Name)
                        })
                        if (element.Type === "address") {
                            argName.textContent = `${element.Type}:`
                            const addressLink = this.config.rendering.renderJustAddressLink(element.Value.address, null, this.chainId)

                            this.appendChildren(block, argName, addressLink)
                            this.appendChildren(callArgumentsPathDiv, block)
                        }
                        if (element.Type.startsWith('uint')) {
                            argName.textContent = `${element.Type}:`
                            let addressNumber = this.config.rendering.renderNumbers(element.Value.bigInteger)

                            this.appendChildren(block, argName, addressNumber)
                            this.appendChildren(callArgumentsPathDiv, block)
                        }
                        if (element.Type.startsWith('bytes')) {
                            argName.textContent = `${element.Type}:`
                            const valueBytes = this.config.rendering.renderBytes32(element.Value.hex)

                            this.appendChildren(block, argName, valueBytes)
                            this.appendChildren(callArgumentsPathDiv, block)
                        }

                    } else {
                        if (element.Type === "address") {
                            argName.textContent = element.Name.length > 1 ? `${element.Name}:` : `${element.Type}:`
                            const addressLink = this.config.rendering.renderJustAddressLink(element.Value.address, null, this.chainId)

                            this.appendChildren(block, argName, addressLink)
                            this.appendChildren(callArgumentsDiv, block)
                        }
                        if (element.Type.startsWith('uint')) {
                            argName.textContent = element.Name.length > 1 ? `${element.Name}:` : `${element.Type}:`
                            let addressNumber = this.config.rendering.renderNumbers(element.Value.bigInteger)

                            this.appendChildren(block, argName, addressNumber)
                            this.appendChildren(callArgumentsDiv, block)
                        }
                        if (element.Type.startsWith('bytes')) {
                            argName.textContent = element.Name.length > 1 ? `${element.Name}:` : `${element.Type}:`
                            const valueBytes = this.config.rendering.renderBytes32(element.Value.hex)

                            this.appendChildren(block, argName, valueBytes)
                            this.appendChildren(callArgumentsDiv, block)
                        }
                    }
                })
                if (item.callArguments.length > 0) {
                    if (item.callArguments.some(e => e.Path.length > 0)) {
                        callArgumentsPathDiv.insertBefore(openingDiv, callArgumentsPathDiv.firstChild);
                        callArgumentsPathDiv.appendChild(closingDiv);
                        callArgumentsPathDiv.insertBefore(pathName, callArgumentsPathDiv.firstChild);
                        this.appendChildren(callDiv, callArgumentsPathDiv);
                    }
                    this.appendChildren(callDiv, callArgumentsDiv);
                }

                if (item.returns.length > 0) {
                    const iconElement = this.createIcon('fa-undo', 'text-danger')

                    const returnContent = this.createElementWithClasses('div', 'content-tree')
                    returnContent.style.gap = '0 5px'
                    returnContent.textContent = '[ Return:'
                    const openingDiv = this.createElementWithClasses('div')
                    openingDiv.textContent = '['
                    const closingDiv = this.createElementWithClasses('div')
                    closingDiv.textContent = ']'
                    item.returns.forEach(element => {
                        const block = this.createElementWithClasses('div', 'text-block', 'ml-2')
                        const argName = this.createElementWithClasses('span', 'name-tree')

                        if (element.Type === "address") {
                            argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`
                            const addressLink = this.config.rendering.renderJustAddressLink(element.Value.address, null, this.chainId)
                            this.appendChildren(block, argName, addressLink, closingDiv)
                        }
                        if (element.Type.startsWith('uint')) {
                            argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`
                            let addressNumber = this.config.rendering.renderNumbers(element.Value.bigInteger)
                            this.appendChildren(block, argName, addressNumber, closingDiv)

                        }
                        if (element.Type.startsWith('bytes')) {
                            argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`
                            let valueBytes = this.config.rendering.renderBytes32(element.Value.hex)
                            this.appendChildren(block, argName, valueBytes, closingDiv)

                        }
                        if (element.Type === "bool") {
                            argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`
                            let valueBytes = document.createElement('span')
                            valueBytes.textContent = element.Value.bool
                            this.appendChildren(block, argName, valueBytes, closingDiv)
                        }
                        this.appendChildren(returnContent, block)

                    })
                    if (item.returns.length > 0) {
                        returnContent.insertBefore(iconElement, returnContent.firstChild);
                        this.appendChildren(callDiv, returnContent)
                    }
                }
                callDiv.appendChild(argumentsDiv);
                contentDiv.appendChild(callDiv);

            }
            if (item.name === 'Event') {
                const argumentsDiv = this.createElementWithClasses('div', 'd-flex', 'flex-wrap', 'event-tree')
                if (counter % 2 !== 0) {
                    argumentsDiv.style.boxShadow = "inset 0 0 0 1000px rgba(0, 0, 0, 0.03)";
                }
                const iconElement = this.createIcon('fa-bolt', 'text-warning')

                argumentsDiv.appendChild(iconElement)

                item.eventArguments.forEach(element => {
                    const block = this.createElementWithClasses('div', 'text-block', 'ml-2')
                    const argName = this.createElementWithClasses('span', 'name-tree')
                    argName.textContent = element.Name.length > 1 ? `${element.Name}:` : `${element.Type}:`

                    if (element.Type === "address") {
                        const addressLink = this.config.rendering.renderJustAddressLink(element.Value.address, null, this.chainId)
                        addressLink.classList.add('value-tree')
                        this.appendChildren(block, argName, addressLink)
                        argumentsDiv.appendChild(block)
                    }
                    if (element.Type.startsWith('uint')) {
                        const addressNumber = this.config.rendering.renderNumbers(element.Value.bigInteger)
                        this.appendChildren(block, argName, addressNumber)
                        argumentsDiv.appendChild(block)
                    }
                    if (element.Type.startsWith('bytes')) {
                        const valueBytes = this.config.rendering.renderBytes32(element.Value.hex)
                        this.appendChildren(block, argName, valueBytes)
                        argumentsDiv.appendChild(block)
                    }
                })
                contentDiv.appendChild(argumentsDiv);
            }

            if (item.children && item.children.length > 0) {
                const childUl = this.createTree(item.children, false, counter);
                details.append(childUl);
            } else {
                summary.classList.add('no-children');
            }


            this.appendChildren(summary, contentDiv)
            this.appendChildren(ul, li)
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

    createIcon(...classes) {
        const icon = document.createElement('i')
        icon.classList.add('fa', 'ml-2', ...classes)
        icon.style.width = '1rem'
        return icon
    }

    createElementWithClasses(elementType, ...classes) {
        const element = document.createElement(elementType);
        element.classList.add(...classes);
        return element;
    }

    appendChildren(parent, ...children) {
        children.forEach(child => parent.appendChild(child));
    }

}
