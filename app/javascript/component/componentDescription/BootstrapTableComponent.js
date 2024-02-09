export default class BootstrapTableComponent {
    constructor(element, historyDataSource, subscriptionDataSource) {
        this.container = element;
        this.historyDataSource = historyDataSource
        this.subscriptionDataSource = subscriptionDataSource
        this.config = this.configuration()
        this.createWrapper()
        this.createTable()
        this.theadCreated = false

    }

    clearData() {
        this.tbody.textContent = ''
    }

    createWrapper() {
        this.wrapper = this.createElementWithClasses('div', 'table-responsive-md');
        this.container.appendChild(this.wrapper);
    }

    createTable() {
        this.tableElement = this.createElementWithClasses('table', 'table', 'table-sm', 'table-striped', 'table-hover');
        const tableLayout = (this.config && this.config.options && this.config.options.tableLayout) || 'fixed';
        this.tableElement.style.tableLayout = tableLayout;
        this.wrapper.appendChild(this.tableElement)

        this.createTbody();
    }

    async createThead(data) {
        if (this.theadCreated) return
        const thead = this.createElementWithClasses('thead')
        thead.classList.add('card-header')
        thead.style.position = 'sticky'
        thead.style.zIndex = '9999'
        const tr = this.createElementWithClasses('tr')
        this.tableElement.appendChild(thead)
        thead.appendChild(tr)
        for (const {name, headerStyle} of this.config.columns) {
            const th = this.createElementWithClasses('th')
            th.setAttribute('scope', 'col')

            if (typeof name === 'function') {
                th.textContent = await name(data)
            } else {
                th.textContent = name
            }

            if (headerStyle) {
                Object.assign(th.style, headerStyle);
            }
            tr.appendChild(th);
        }
        this.theadCreated = true
    }


    createTbody() {
        this.tbody = this.createElementWithClasses('tbody');
        this.tableElement.appendChild(this.tbody)
    }

    async init(widgetFrame) {
        if (this.historyDataSource) {
            this.historyDataSource.setCallback(this.onHistoryData.bind(this))
        }
        if (this.subscriptionDataSource) {
            this.subscriptionDataSource.setCallback(this.onSubscriptionData.bind(this))
        } else {
            widgetFrame && widgetFrame.setupShowMoreButton()
        }

    }

    async onHistoryData(data, variables) {
        if (this.config.title) {
            await this.getTitle(data)
        }
        if (this.config.topElement(data).length === 0) {
            this.container.textContent = 'No Data. Response is empty'
            return;
        }
        await this.createThead(data)
        while (this.tbody.children.length) {
            this.tbody.removeChild(this.tbody.firstChild)
        }
        const rows = await this.composeRows(data, variables)
        // this.appendChildren(this.tbody, rows);
        rows.forEach((row, index) => {
            setTimeout(() => {
                row.classList.add('tr-animate')
                this.tbody.insertBefore(row, this.tbody.firstChild)
            }, 200 * index);
        });

    }

    async onSubscriptionData(data, variables) {
        if (this.config.title) {
            await this.getTitle(data)
        }
        const maxRows = 15;
        const rows = await this.composeRows(data, variables)
        rows.forEach((row, index) => {
            setTimeout(() => {
                row.classList.add('tr-animate')

                this.tbody.insertBefore(row, this.tbody.firstChild)
                if (this.tbody.childElementCount > maxRows) {
                    this.tbody.removeChild(this.tbody.lastChild);
                }
            }, 200 * index)
        })
    }

    async composeRows(rowData, variables) {
        const data = this.config.topElement(rowData)
        const rows = []
        if (data) {
            let chainId = ''
            if (data.length > 0) {
                chainId = this.config.chainId(rowData)
            }
            for (const row of data) {
                const tr = this.createElementWithClasses('tr')
                for (const column of this.config.columns) {
                    const td = this.createElementWithClasses('td', 'text-truncate');
                    const textCell = this.createElementWithClasses('span');
                    textCell.textContent = column.cell(row)
                    textCell.setAttribute('title', column.cell(row))
                    if (textCell.textContent === 'true') {
                        textCell.style.color = '#2EA848'
                    }
                    td.appendChild(textCell)

                    if (column.rendering) {
                        const div = await column.rendering(column.cell(row), variables, chainId)
                        td.replaceChild(div, textCell)
                    }
                    if (column.cellStyle) {
                        Object.assign(td.style, column.cellStyle)
                    }

                    tr.appendChild(td);
                }
                    rows.push(tr)
            }
        }
        return rows
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

    createElementWithClasses(elementType, ...classes) {
        const element = document.createElement(elementType);
        element.classList.add(...classes);
        return element;
    }

    appendChildren(parent, children) {
        children.forEach(child => parent.appendChild(child));
    }
}