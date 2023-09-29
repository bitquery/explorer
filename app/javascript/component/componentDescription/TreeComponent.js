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
        this.chainId = this.config.chainId(data);
        if (data.EVM.Calls.length < 1 && data.EVM.Events.length < 1) {
            this.container.textContent = 'No Data. Response is empty';
            return;
        }

        const expandButton = this.createElementWithClasses('button', 'btn', 'btn-outline-secondary', 'btn-sm', 'expand-button-tree');
        const iconElementExpand = this.createIcon('fa-expand', 'text-secondary')
        // expandButton.textContent = '+';
        this.appendChildren(expandButton,iconElementExpand)
        expandButton.addEventListener('click', this.expandAll.bind(this));

        const collapseButton = this.createElementWithClasses('button', 'btn', 'btn-outline-secondary', 'btn-sm', 'collapse-button-tree');
        const iconElementCollapse = this.createIcon('fa-compress', 'text-secondary')
        this.appendChildren(collapseButton,iconElementCollapse)

        // collapseButton.textContent = '-';
        collapseButton.addEventListener('click', this.collapseAll.bind(this))

        const dataTree = this.buildTree(this.config.topElement(data));
        const tree = this.createTree(dataTree, true);
        this.appendChildren(this.container, expandButton, collapseButton, tree)


        let lastScrollY = window.scrollY;

        window.addEventListener('scroll', () => {
            const {top, bottom} = this.container.getBoundingClientRect();
            const collapseButton = this.container.querySelector('.collapse-button-tree');
            if (!collapseButton) return;

            const containerTop = top + window.scrollY + 25;
            const containerBottom = bottom + window.scrollY - collapseButton.offsetHeight;
            let newPosition = window.scrollY + window.innerHeight / 2;

            newPosition = Math.max(newPosition, (lastScrollY > window.scrollY && newPosition < containerTop + 100) ? containerTop + 100 : containerTop);
            newPosition = Math.min(newPosition, containerBottom);

            lastScrollY = window.scrollY;
            collapseButton.style.position = 'absolute';
            collapseButton.style.top = `${newPosition - containerTop}px`;
        });

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
                const parentArray = call.Call.Depth === 0 ? tree : lastParentNodes[call.Call.Depth - 1].children;
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
                    parentArray.push(eventNode);
                });
            }
        });
        return tree;
    }

    createTree(data, isRoot = false, counter = {value: 0}) {

        const ul = this.createElementWithClasses('ul', 'ul-tree')
        if (isRoot) ul.id = 'tree';
        data.forEach(item => {
            counter.value++;
            const li = this.createElementWithClasses('li', 'li-tree')
            const details = this.createElementWithClasses('details')

            details.addEventListener('toggle', () => {
                this.updateCollapseButton();
            });
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
                iconElement = this.createIcon('fa-share', 'text-primary','ml-2')
            }


            const method = this.config.rendering.renderMethodLink({
                method: item.signature.Signature.Name,
                hash: item.signature.Signature.SignatureHash,
            }, null, this.chainId)
            if (item.signature.Signature.SignatureHash === '') method.textContent = 'transfer of money'
            const gas = this.createElementWithClasses('div')
            if (item.signature.Gas) {
                gas.textContent = `Gas: ${item.signature.Gas}`
                const gasUsed = this.createElementWithClasses('div')
                gasUsed.textContent = `Gas used: ${item.signature.GasUsed}`
                this.appendChildren(contentDiv, iconElement, method, gas, gasUsed)
            }

            const argumentsDiv = this.createElementWithClasses('div', 'event-tree')
            const callArgumentsDiv = this.createElementWithClasses('div', 'content-tree')
            const callArgumentsPathDiv = this.createElementWithClasses('div', 'content-tree')
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
                if (callArgumentsPathDiv.childElementCount !== 0) {
                    callArgumentsPathDiv.insertBefore(openingDiv, callArgumentsPathDiv.firstChild);
                    callArgumentsPathDiv.appendChild(closingDiv);
                    callArgumentsPathDiv.insertBefore(pathName, callArgumentsPathDiv.firstChild);
                    this.appendChildren(contentDiv, callArgumentsPathDiv);
                }
                this.appendChildren(contentDiv, callArgumentsDiv);
            }
            if (item.name === 'Event') {
                const iconElement = this.createIcon('fa-bolt', 'text-warning','ml-2')
                callArgumentsDiv.insertBefore(iconElement, callArgumentsDiv.firstChild);
            }

            if (item.returns && item.returns.length > 0) {
                const iconElement = this.createIcon('fa-undo', 'text-danger','ml-2')
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

                    if (index < item.returns.length - 1) {
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
        if (collapseButton) collapseButton.style.display = 'none';
    }

    updateCollapseButton() {
        const isOpen = [...this.container.querySelectorAll('details')].some(details => details.open);
        const collapseButton = this.container.querySelector('.collapse-button-tree');
        if (collapseButton) collapseButton.style.display = isOpen ? 'block' : 'none';
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
        // console.log('parent', parent)
        children.forEach(child => {
            // console.log('child', child)
            parent.appendChild(child)
        });
    }

}
