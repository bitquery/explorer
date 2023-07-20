export default class BootstrapTableComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
    this.createWrapper();
    this.createTable();
    this.data = null;
  }
 async clearData() {
    await this.data;
    this.tbody.textContent=''
  }
  createWrapper() {
    this.wrapper = this.createElementWithClasses('div', 'table-responsive-md','d-flex');
    this.appendChildren(this.container, this.wrapper);
  }

  createTable() {
    this.tableElement = this.createElementWithClasses('table', 'table', 'table-sm', 'table-striped', 'table-hover');
    this.tableElement.style.tableLayout = 'fixed';
    this.tableElement.style.width = '100%';
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

    this.config.columns.forEach(({name}) => {
      const th = this.createElementWithClasses('th');
      th.setAttribute('scope', 'row');
      th.textContent = name;
      this.appendChildren(tr, th);
    });
  }

  createTbody() {
    this.tbody = this.createElementWithClasses('tbody');
    this.appendChildren(this.tableElement, this.tbody);
  }

  createTfooter() {
    const tfooter = this.createElementWithClasses('div');
    this.appendChildren(this.tableElement, tfooter);
  }

  async onData(data, sub) {
     this.data = this.config.topElement(data);
    let chainId=''
    if(this.data.length > 0){
       chainId =  this.config.chainId(data)
    }
    const maxRows = 15;

    for (const rowData of this.data) {
      const tr = this.createElementWithClasses('tr');

      for (const column of this.config.columns) {
        const td = this.createElementWithClasses('td');
        // ,"text-truncate"
        const textCell = this.createElementWithClasses('span');
        textCell.textContent = column.cell(rowData);
        this.appendChildren(td, textCell);

        if (column.rendering) {
          const div = await column.rendering(column.cell(rowData), this.variables, chainId);

          td.replaceChild(div, textCell);
        }

        tr.appendChild(td);
      }
      if (sub) {
        this.tbody.insertBefore(tr, this.tbody.firstChild);
        if (this.tbody.childElementCount > maxRows) {
          this.tbody.removeChild(this.tbody.lastChild);
        }
      } else {
        this.appendChildren(this.tbody, tr);
      }
    }
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