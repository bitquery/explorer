export default class BootstrapTableComponent {
    constructor(element, historyDataSource, subscriptionDataSource) {
        this.container = element;
        this.historyDataSource = historyDataSource
        this.subscriptionDataSource = subscriptionDataSource
        this.config = this.configuration()
        this.createWrapper()
        this.createTable()
        this.theadCreated = false
        if (this.config.theme) {
            this.setTheme(this.config.theme);
        }

    }

    clearData() {
        this.tbody.textContent = ''
    }

    createWrapper() {
        this.wrapper = this.createElementWithClasses('div', 'table-responsive-md');
        this.container.appendChild(this.wrapper);
    }

    createTable() {
        this.tableElement = this.createElementWithClasses('table',  'table','table-sm', 'table-striped', 'table-hover');
        this.tableElement.style.fontSize = '0.9rem';
        this.tableElement.style.tableLayout = (this.config && this.config.options && this.config.options.tableLayout) || 'fixed';
        this.wrapper.appendChild(this.tableElement)

        this.createTbody();
    }

    async createThead(data) {
        if (this.theadCreated) return
        const thead = this.createElementWithClasses('thead')
        thead.style.position = 'sticky'
        thead.style.background = '#F8F8F8'
        thead.style.color = '#495057'
        thead.style.zIndex = '9999'
        const tr = this.createElementWithClasses('tr')
        this.tableElement.appendChild(thead)
        thead.appendChild(tr)
        for (const {name, headerStyle} of this.config.columns) {
            const th = this.createElementWithClasses('th')
            th.setAttribute('scope', 'col')
            th.style.padding = '0.3rem 0.5rem'
            // th.style.whiteSpace = 'nowrap'
            th.style.fontWeight = 'bold'

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
        rows.forEach(row => {
        this.appendChildren(this.tbody, rows);
                // this.tbody.insertBefore(row, this.tbody.firstChild)
        })

    }

    async onSubscriptionData(data, variables) {
        if (this.config.title) {
            await this.getTitle(data)
        }
        await this.createThead(data)

        const maxRows = 15;
        const rows = await this.composeRows(data, variables)
        rows.forEach((row, index) => {
            // setTimeout(() => {
            //     row.classList.add('tr-animate')
                this.tbody.insertBefore(row, this.tbody.firstChild)
                if (this.tbody.childElementCount > maxRows) {
                    this.tbody.removeChild(this.tbody.lastChild);
                }
            // }, 200 * index)
        })
    }

    async composeRows(rowData, variables) {
        const data = this.config.topElement(rowData);

        if (!data || data.length === 0) return [];

        const chainId = data.length > 0 ? this.config.chainId(rowData) : '';

        const rows = await Promise.all(data.map(async (row) => {
            const tr = this.createElementWithClasses('tr');

            for (const column of this.config.columns) {
                const td = this.createElementWithClasses('td', 'text-truncate');
                td.style.borderTop = 'none'
                td.style.padding = '0.3rem 0.5rem'
                td.style.fontSize = '0.9rem'

                const textCell = this.createElementWithClasses('span');
                const cellValue = column.cell(row);

                textCell.textContent = cellValue;
                textCell.setAttribute('title', cellValue);

                if (cellValue === 'true' || cellValue === 'Success') {
                    textCell.style.color = '#2EA848';
                }

                td.appendChild(textCell);

                if (column.rendering) {
                    const div = await column.rendering(cellValue, variables, chainId);
                    td.replaceChild(div, textCell);
                }

                if (column.cellStyle) {
                    Object.assign(td.style, column.cellStyle);
                }

                tr.appendChild(td);
            }

            return tr;
        }));

        return rows;
    }
    setTheme(theme) {
        if (theme === 'dark') {
            this.tableElement.classList.add('table-dark');
        } else {
            this.tableElement.classList.remove('table-dark');
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

    createElementWithClasses(elementType, ...classes) {
        const element = document.createElement(elementType);
        element.classList.add(...classes);
        return element;
    }

    appendChildren(parent, children) {
        children.forEach(child => parent.appendChild(child));
    }
}