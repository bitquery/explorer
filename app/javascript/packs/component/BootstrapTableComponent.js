export default class BootstrapTableComponent {
  constructor(element) {
    this.container = element;
    this.config = this.configuration();
    this._createWrapper();
    this._createTable();
  }

  _createWrapper() {
    this.wrapper = document.createElement('div');
    this.wrapper.classList.add('table-responsive');
    this.container.appendChild(this.wrapper);
  }

  _createTable() {
    this.tableElement = document.createElement('table');
    this.tableElement.classList.add(
      'table',
      'table-striped',
      'table-hover',
      'table-sm'
    );
    this.wrapper.appendChild(this.tableElement);

    this._createThead();
    this._createTbody();
    this._createTfooter();
  }

  _createThead() {
    const thead = document.createElement('thead');
    this.tableElement.appendChild(thead);

    const tr = document.createElement('tr');
    thead.appendChild(tr);

    this.config.columns.forEach((column) => {
      const th = document.createElement('th');
      const thText = document.createElement('span');
      th.setAttribute('scope', 'col');
      thText.textContent = column.name;
      tr.appendChild(th);
      th.appendChild(thText);
    });
  }

  _createResizeEmptySpace(extraClass) {
    const div = document.createElement('div');
    div.classList.add('tabulator-col-resize-handle');
    if (extraClass) div.classList.add(extraClass);
    return div;
  }

  _createTbody() {
    this.tbody = document.createElement('tbody');
    this.tableElement.appendChild(this.tbody);
  }

  _createTfooter() {
    const tfooter = document.createElement('div');
    this.tableElement.appendChild(tfooter);
  }
  onData = (data, sub) => {
    console.log('onData', data);
    const array = this.config.topElement(data);
    const maxRows = 10;

    array.forEach((rowData) => {
      const tr = document.createElement('tr');
      this.tbody.appendChild(tr);
      this.config.columns.forEach((column) => {
        const td = document.createElement('td');
        const textCell = document.createElement('span');
        td.classList.add('tabulator-cell', 'ellipsis');
        td.setAttribute('role', 'gridcell');

        if (column.type === 'link') {
          this._createLinkCellContent(textCell, rowData, column);
        } else {
          textCell.textContent = column.cell(rowData);
        }
        if (column.type === 'date') {
          this._createDateCellContent(textCell, rowData, column);
        }
        tr.appendChild(td);
        td.appendChild(textCell);
      });
      if (sub) {
        this.tbody.insertBefore(tr, this.tbody.firstChild);
        if (this.tbody.childElementCount > maxRows) {
          this.tbody.removeChild(this.tbody.lastChild);
        }
      } else {
        this.tbody.appendChild(tr);
      }
    });
  };

  _createDateCellContent(textCell, rowData, column) {
    const result = new Date(column.cell(rowData)).toLocaleString();
    textCell.textContent = result;
  }

  _createLinkCellContent(textCell, rowData, column) {
    const link = document.createElement('a');
    link.setAttribute('target', '_blank');
    link.href = `${column.cell(rowData)}`; // Change  URL
    link.textContent = column.cell(rowData);
    textCell.appendChild(link);
  }
}
