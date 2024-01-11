export default class BootstrapVerticalTableComponent {
    constructor(element, historyDataSource, subscriptionDataSource) {
        this.container = element;
        this.config = this.configuration();
        this.historyDataSource = historyDataSource
        this.subscriptionDataSource = subscriptionDataSource
        this.createWrapper();
        this.createTable();
    }

    createWrapper() {
        this.wrapper = this.createElementWithClasses('div', 'table-responsive-md');
        this.appendChildren(this.container, this.wrapper);
    }

    createTable() {
        this.tableElement = this.createElementWithClasses('table', 'table', 'table-sm', 'table-striped', 'table-hover');
        this.tableElement.style.tableLayout = 'fixed';
        this.appendChildren(this.wrapper, this.tableElement);
        this.createThead();
        this.createTbody();
        this.createTfooter();
    }

    createThead() {
        const thead = this.createElementWithClasses('thead');
        const tr = this.createElementWithClasses('tr');
        this.appendChildren(this.tableElement, thead);
        this.appendChildren(thead, tr);

        const th1 = this.createElementWithClasses('th');
        th1.setAttribute('scope', 'row');
        th1.textContent = (this.config && this.config.options && this.config.options.columnTitle1) ? this.config.options.columnTitle1 : 'Property';
        th1.style.width = '30%'
        this.appendChildren(tr, th1);

        const th2 = this.createElementWithClasses('th');
        th2.setAttribute('scope', 'row');
        th2.textContent = (this.config && this.config.options && this.config.options.columnTitle2) ? this.config.options.columnTitle2 : 'Value';
        this.appendChildren(tr, th2);
    }

    createTbody() {
        this.tbody = this.createElementWithClasses('tbody');
        this.appendChildren(this.tableElement, this.tbody);
    }

    createTfooter() {
        const tfooter = this.createElementWithClasses('div');
        this.appendChildren(this.tableElement, tfooter);
    }

    async init() {
        if (this.historyDataSource) {
            this.historyDataSource.setCallback(this.onHistoryData.bind(this))
        }
        if (this.subscriptionDataSource) {
            this.subscriptionDataSource.setCallback(this.onSubscriptionData.bind(this))
        }
    }

    async onHistoryData(data, variables) {
        try {
            if (this.config.title && data) {
                await this.getTitle(data)
            }
            if(this.config.topElement(data).length===0){
                this.container.textContent = 'No Data. Response is empty'
                return
            }
            const array = this.config.topElement(data);
            const chainId = this.config.chainId(data)
            for (const rowData of array) {
                for (const column of this.config.columns) {
                    if (column.cell(rowData) === undefined) {
                        continue
                    }
                    const tr = this.createElementWithClasses('tr');
                    const td1 = this.createElementWithClasses('td');
                    const textCell1 = this.createElementWithClasses('span', 'text-info', 'font-weight-bold');
                    textCell1.textContent = column.name;
                    this.appendChildren(td1, textCell1);

                    const td2 = this.createElementWithClasses('td');
                    const textCell2 = this.createElementWithClasses('span');
                    textCell2.textContent = column.cell(rowData);
                    this.appendChildren(td2, textCell2);

                    if (column.rendering) {
                        const div = await column.rendering(column.cell(rowData), variables, chainId);
                        td2.replaceChild(div, textCell2);
                    }
                    if (column.cellStyle) {
                        const cellStyle = column.cellStyle;
                        for (let styleKey in cellStyle) {
                            td2.style[styleKey] = cellStyle[styleKey];
                        }
                    }
                    this.appendChildren(tr, td1, td2);
                    this.appendChildren(this.tbody, tr);

                }

            }
        } catch (error) {
            this.displayError(`Error processing data: ${error.message}`);
        }
    }

    async onSubscriptionData(data, variables) {
        try {
            const array = this.config.topElement(data);
            const chainId = this.config.chainId(data)

            const maxRows = 15;
            for (const rowData of array) {
                for (const column of this.config.columns) {
                    const tr = this.createElementWithClasses('tr');

                    const td1 = this.createElementWithClasses('td');
                    const textCell1 = this.createElementWithClasses('span', 'text-info', 'font-weight-bold');
                    textCell1.textContent = column.name;
                    this.appendChildren(td1, textCell1);

                    const td2 = this.createElementWithClasses('td');
                    const textCell2 = this.createElementWithClasses('span');
                    textCell2.textContent = column.cell(rowData);
                    this.appendChildren(td2, textCell2);

                    if (column.rendering) {
                        const div = await column.rendering(column.cell(rowData), variables, chainId);
                        td2.replaceChild(div, textCell2);
                    }

                    this.appendChildren(tr, td1, td2);

                    this.tbody.insertBefore(tr, this.tbody.firstChild);

                    if (this.tbody.childElementCount > maxRows) {
                        this.tbody.removeChild(this.tbody.lastChild);
                    }
                }
            }
        } catch (error) {
            this.displayError(`Error processing data: ${error.message}`)
        }
    }

    async getTitle(data) {
        if (this.config && this.config.title && this.config.id) {

            const divTitle = document.querySelector(`.\\#${this.config.id}`)
            if (divTitle) {
                const textNode = document.createTextNode(this.config.title(data))
                divTitle.textContent = ''
                divTitle.appendChild(textNode)
            }
        }
    }

    displayError(message) {
        this.wrapper.textContent = ''
        const errorDiv = this.createElementWithClasses('div', 'alert', 'alert-danger')
        errorDiv.textContent = message
        this.appendChildren(this.wrapper, errorDiv)
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