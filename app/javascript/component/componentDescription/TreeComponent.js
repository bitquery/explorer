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
        try {
            this.container.style.scrollBehavior = 'smooth';
            this.container.style.margin = '0';
            this.chainId = this.config.chainId(data);
            if (data.EVM.Calls.length < 1 && data.EVM.Events.length < 1) {
                this.container.textContent = 'No Data. Response is empty';
                return;
            }

            const expandButton = this.createElementWithClasses('button', 'btn', 'btn-outline-secondary', 'btn-sm', 'expand-button-tree');
            expandButton.textContent = 'Expand all'
            expandButton.addEventListener('click', this.expandAll.bind(this));

            const collapseButton = this.createElementWithClasses('button', 'btn', 'btn-outline-secondary', 'btn-sm', 'collapse-button-tree');
            collapseButton.textContent = 'Collapse all'
            collapseButton.addEventListener('click', this.collapseAll.bind(this))

            const buttonContainer = this.createElementWithClasses('div', 'button-container');
            this.appendChildren(buttonContainer, expandButton, collapseButton);

            const dataTree = this.buildTree(this.config.topElement(data));
            const tree = this.createTree(dataTree, true);
            this.appendChildren(this.container, buttonContainer, tree);
        } catch (error) {
            this.displayError(`Error processing data: ${error.message}`)
        }
    }

    buildTree(evmData) {
        let tree = [];
        let lastParentNodes = {};
        evmData.Calls.forEach(call => {
            if (call && call.Call) {
                const newNode = {
                    name: 'Call',
                    signature: call.Call,
                    returns: call.Returns,
                    arguments: call.Arguments,
                    children: []
                };
                const parentArray = call.Call.Depth === 0 ? tree : (lastParentNodes[call.Call.Depth - 1] && lastParentNodes[call.Call.Depth - 1].children) ? lastParentNodes[call.Call.Depth - 1].children : [];
                parentArray.push(newNode);
                lastParentNodes[call.Call.Depth] = newNode;

                const eventForCall = evmData.Events
                    .sort((a, b) => a.Log.Index - b.Log.Index)
                    .filter(event => event.Log && event.Call.Index === call.Call.Index);

                eventForCall.forEach(event => {
                    const eventNode = {
                        name: 'Event',
                        signature: event.Log,
                        arguments: event.Arguments,
                        children: [],
                    };
                    if (event.Log && event.Log.Signature.SignatureHash === '') return
                    parentArray.push(eventNode);
                });

                if (!evmData.Transfers) return
                const transferForCall = evmData.Transfers
                    .sort((a, b) => a.Call.Index - b.Call.Index)
                    .filter(transfer => transfer.Call && transfer.Call.Index === call.Call.Index);

                transferForCall.forEach(transfer => {

                    const transferNode = {
                        name: 'Transfers',
                        signature: transfer.Call,
                        dataTransfer: transfer.Transfer,
                        arguments: [],
                        children: [],
                    };
                    parentArray.push(transferNode);
                });
            }
        });
        return tree;
    }

    createTree(data, isRoot = false, counter = {value: 0}) {

        const ul = this.createElementWithClasses('ul', 'ul-tree')
        if (isRoot) ul.id = 'tree';
        data.forEach((item, index) => {
            if (item.name === 'Call' && item.signature && item.signature.Signature.SignatureHash === '') {
                return
            }
            counter.value++;
            const li = this.createElementWithClasses('li', 'li-tree')
            const details = this.createElementWithClasses('details')
            details.setAttribute('open', '')
            const summary = this.createElementWithClasses('summary', 'summary-tree', 'card', 'mb-1')
            this.appendChildren(details, summary)
            this.appendChildren(li, details)
            let iconElement
            const openingDiv = this.createElementWithClasses('div')
            openingDiv.textContent = '('
            const closingDiv = this.createElementWithClasses('div')
            closingDiv.textContent = ')'
            const pathName = this.createElementWithClasses('div', 'name-tree')
            const contentDiv = this.createElementWithClasses('div', 'content-tree')
            if (counter.value % 2 !== 0) {
                contentDiv.style.boxShadow = 'inset 0 0 0 1000px rgba(0, 0, 0, 0.03)'
            }

            if (item.name === 'Call') {
                iconElement = this.createIcon('fa-share', 'text-primary', 'ml-2')
            }

            if (item.signature.Gas && item.signature.Signature.SignatureHash !== '') {
                const method = this.config.rendering.renderMethodLink({
                    method: item.signature.Signature.Name,
                    hash: item.signature.Signature.SignatureHash,
                }, null, this.chainId)
                method.style.fontWeight = 'bold'

                this.appendChildren(contentDiv, iconElement, method)
            }


            const argumentsDiv = this.createElementWithClasses('div', 'event-tree', 'argumentsDiv')
            const callArgumentsDiv = this.createElementWithClasses('div', 'content-tree', 'callArgumentsDiv')
            const callArgumentsPathDiv = this.createElementWithClasses('div', 'content-tree', 'callArgumentsPathDiv')
            let value
            item.arguments.forEach((element, index) => {
                const block = this.createElementWithClasses('div', 'text-block');
                const argName = this.createElementWithClasses('div', 'name-tree');
                const value = this.getValueFromType(element);

                if (element.Path.length > 0) {
                    pathName.textContent = `${element.Path[0].Name}:`;
                    argName.textContent = `${element.Type}:`;
                    this.appendChildren(block, argName, value);
                    this.appendChildren(callArgumentsPathDiv, block);
                } else {
                    argName.textContent = element.Name.length > 1 ? `${element.Name}:` : `${element.Type}:`;
                    this.appendChildren(block, argName, value);
                    this.appendChildren(callArgumentsDiv, block);
                }

                if (index < item.arguments.length - 1) {
                    const comma = document.createTextNode(', ');
                    if (element.Path.length > 0) {
                        callArgumentsPathDiv.appendChild(comma);
                    } else {
                        callArgumentsDiv.appendChild(comma);
                    }
                }
            });
            if (item.arguments.length > 0) {
                if (callArgumentsDiv.childElementCount !== 0) {
                    callArgumentsDiv.insertBefore(openingDiv, callArgumentsDiv.firstChild);
                    callArgumentsDiv.appendChild(closingDiv);
                    callArgumentsDiv.insertBefore(pathName, callArgumentsDiv.firstChild);
                    this.appendChildren(contentDiv, callArgumentsDiv);
                }
                this.appendChildren(contentDiv, callArgumentsDiv);
            }

            if (item.name === 'Event') {
                const iconElement = this.createIcon('fa-bolt', 'text-warning', 'ml-2')
                const method = this.config.rendering.renderMethodLink({
                    method: item.signature.Signature.Name,
                    hash: item.signature.Signature.SignatureHash,
                }, null, this.chainId)
                method.style.fontWeight = 'bold'

                callArgumentsDiv.insertBefore(method, callArgumentsDiv.firstChild);
                callArgumentsDiv.insertBefore(iconElement, callArgumentsDiv.firstChild);
            }
            if (item.name === 'Transfers') {
                const senderDiv = this.createElementWithClasses('div', 'text-block');
                const receiverDiv = this.createElementWithClasses('div', 'text-block');
                const iconElement = this.createIcon('fa', 'fa-money', 'text-success', 'ml-2');
                const iconSenderReceiver = this.createIcon('fa', 'fa-arrow-right', 'text-success');
                const sender = this.config.rendering.renderJustAddressLink(item.dataTransfer.Sender, null, this.chainId)
                const receiver = this.config.rendering.renderJustAddressLink(item.dataTransfer.Receiver, null, this.chainId)
                const amountDiv = this.config.rendering.renderNumbers(item.dataTransfer.Amount)
                const currency = this.createElementWithClasses('div')
                currency.textContent = item.dataTransfer.Currency.Symbol

                this.appendChildren(senderDiv, sender);
                this.appendChildren(receiverDiv, receiver);
                this.appendChildren(contentDiv, iconElement, amountDiv, currency, senderDiv, iconSenderReceiver, receiverDiv);

            }
            if (item.name === 'Call') {
                const fromToDiv = this.createElementWithClasses('div', 'content-tree')
                const senderDiv = this.createElementWithClasses('div', 'text-block');
                const receiverDiv = this.createElementWithClasses('div', 'text-block');
                const iconSenderReceiver = this.createIcon('fa', 'fa-arrow-right', 'text-success');
                const sender = this.config.rendering.renderJustAddressLink(item.signature.From, null, this.chainId)
                const receiver = this.config.rendering.renderJustAddressLink(item.signature.To, null, this.chainId)
                const gas = this.createElementWithClasses('div')
                gas.textContent = `Gas: ${item.signature.Gas}`
                const gasUsed = this.createElementWithClasses('div')
                gasUsed.textContent = `Gas used: ${item.signature.GasUsed}`
                this.appendChildren(senderDiv, sender);
                this.appendChildren(receiverDiv, receiver);
                if (item.signature.CallerIndex === -1) {
                    this.appendChildren(fromToDiv, senderDiv, iconSenderReceiver, receiverDiv, gas, gasUsed);
                    this.appendChildren(contentDiv, fromToDiv);
                } else {
                    this.appendChildren(fromToDiv, iconSenderReceiver, receiverDiv, gas, gasUsed);
                    this.appendChildren(contentDiv, fromToDiv);
                }
            }

            if (item.returns && item.returns.length > 0) {
                const iconElement = this.createIcon('fa-undo', 'text-danger', 'ml-2')
                const returnContent = this.createElementWithClasses('div', 'content-tree')
                returnContent.textContent = '[ Return:'
                returnContent.style.gap = '0 5px'
                const closingDiv = this.createElementWithClasses('div')
                closingDiv.textContent = ']'

                item.returns.forEach((element, index) => {
                    const block = this.createElementWithClasses('div', 'content-tree')
                    const argName = this.createElementWithClasses('div', 'text-block');
                    const value = this.getValueFromType(element)
                    argName.textContent = element.Name ? `${element.Name}:` : `${element.Type}:`

                    this.appendChildren(block, argName, value)
                    this.appendChildren(returnContent, block, closingDiv)

                    if (index < item.returns.length - 2) {
                        const comma = document.createTextNode(', ')
                        returnContent.appendChild(comma)
                    }
                })

                returnContent.insertBefore(iconElement, returnContent.firstChild)
                this.appendChildren(contentDiv, returnContent)
            }

            this.appendChildren(contentDiv, argumentsDiv)

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

    getValueFromType(element) {
        let value
        if (element.Type.startsWith('address')) {
            value = this.config.rendering.renderJustAddressLink(element.Value.address, null, this.chainId)
        } else if (element.Type.startsWith('uint') || element.Type.startsWith('int')) {
            value = this.config.rendering.renderNumbers(element.Value.bigInteger || element.Value.integer);
        } else if (element.Type.startsWith('bytes')) {
            value = this.config.rendering.renderBytes32(element.Value.hex)
        } else if (element.Type.startsWith('bool')) {
            value = document.createElement('div')
            value.textContent = element.Value.bool
        } else if (element.Type.startsWith('string')) {
            value = document.createElement('div')
            value.textContent = element.Value.string
        }
        return value
    }

    expandAll() {
        this.container.querySelectorAll('details').forEach(details => details.open = true);
        const collapseButton = this.container.querySelector('.collapse-button-tree');
        if (collapseButton) collapseButton.style.display = 'block';
    }

    collapseAll() {
        this.container.querySelectorAll('details').forEach(details => details.open = false)
        const collapseButton = this.container.querySelector('.collapse-button-tree');
    }

    createIcon(...classes) {
        const icon = this.createElementWithClasses('i', 'fa', ...classes)
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

    displayError(message) {
        this.container.textContent = ''
        const errorDiv = this.createElementWithClasses('div', 'alert', 'alert-danger')
        errorDiv.textContent = message
        this.appendChildren(this.container, errorDiv)
    }

}
