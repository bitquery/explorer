export default class BootstrapCardComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
    this.wrapper = this.createElementWithClasses('div', 'row');
    this.row = this.createElementWithClasses('div', 'row','col');

    this.wrapper.appendChild(this.row);
    this.container.appendChild(this.wrapper);
  }

  createElementWithClasses(elementType, ...classes) {
    const element = document.createElement(elementType);
    element.classList.add(...classes);
    return element;
  }

  async onData(data, sub) {
    const array = this.config.topElement(data);
    this.chainId =  this.config.chainId(data);
    const maxRows = 10;

    for (const rowData of array) {
      const cardElement = await this.createCardElement(rowData);
      if (sub) {
        this.row.insertBefore(cardElement, this.row.firstChild);
        if (this.row.childElementCount > maxRows) {
          this.row.removeChild(this.row.lastChild);
        }
      } else {
        this.row.appendChild(cardElement);
      }
    }
  }

  async createCardElement(rowData) {
    const cardElement = this.createElementWithClasses('div', 'card', 'm-1','col-sm');
    cardElement.style.minWidth = '430px'
    const row = this.createElementWithClasses('div', 'row', 'no-gutters');
    const [cardImg, cardTable] = await this.createCardSections(rowData);
    this.appendChildren(cardElement, row);
    this.appendChildren(row, cardImg, cardTable);
    return cardElement;
  }

  async createCardSections(rowData) {
    const cardImg = this.createElementWithClasses('div', 'col-4', 'd-flex', 'flex-column');
  cardImg.style.maxHeight = '100%';

    for (const column of this.config.image) {
     if (column.rendering) {
      const imgElement = await column.rendering(column.cell(rowData), this.variables, this.chainId);
      imgElement.classList.add('row', 'no-gutters' ,'flex-grow-1');
      this.appendChildren(cardImg, imgElement);
    }
    }

    const cardTable = this.createElementWithClasses('div', 'col-8');
    const tableElement = this.createElementWithClasses('table', 'table', 'table-sm', 'table-striped', 'table-hover');
    tableElement.style.tableLayout = 'fixed';
    cardTable.appendChild(tableElement);

    const tbody = this.createElementWithClasses('tbody');
    tableElement.appendChild(tbody);

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
        const div = await column.rendering(column.cell(rowData), this.variables, this.chainId);
        td2.replaceChild(div, textCell2);
      }

      this.appendChildren(tr, td1, td2);
      this.appendChildren(tbody, tr);
    }

    return [cardImg, cardTable];
  }

  appendChildren(parent, ...children) {
    children.forEach(child => parent.appendChild(child));
  }
}
