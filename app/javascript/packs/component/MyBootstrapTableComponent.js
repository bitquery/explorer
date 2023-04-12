export default class MyBootstrapTableComponent {
  constructor(element) {
    this.container = element;
    this.config = this.configuration();
    this.#createWrapper();
    this.#createTable();
  }

  #createWrapper() {
    this.wrapper = document.createElement('div');
    this.wrapper.classList.add('table-responsive');
    // this.wrapper.style.height = '70vh';
    this.container.appendChild(this.wrapper);
  }

  #createTable() {
    this.tableElement = document.createElement('table');
    this.tableElement.classList.add(
      'table',
      'table-striped',
      'table-hover',
      'table-sm'
    );
    this.wrapper.appendChild(this.tableElement);

    this.#createThead();
    this.#createTbody();
    this.#createTfooter();
  }

  #createThead() {
    const thead = document.createElement('thead');
    // thead.classList.add('tabulator-header');
    this.tableElement.appendChild(thead);

    const tr = document.createElement('tr');
    thead.appendChild(tr);

    this.config.columns.forEach((column) => {
      const th = document.createElement('th');
      const thText = document.createElement('span');
      // th.classList.add('tabulator-col-title');
      th.setAttribute('scope', 'col');
      thText.textContent = column.name;
      tr.appendChild(th);
      th.appendChild(thText);

      // tr.appendChild(this.#createResizeEmptySpace());
      // tr.appendChild(this.#createResizeEmptySpace('prev'));
    });
  }

  #createResizeEmptySpace(extraClass) {
    const div = document.createElement('div');
    div.classList.add('tabulator-col-resize-handle');
    if (extraClass) div.classList.add(extraClass);
    return div;
  }

  #createTbody() {
    this.tbody = document.createElement('tbody');
    // this.tbody.classList.add('tabulator-table');
    this.tableElement.appendChild(this.tbody);
  }

  #createTfooter() {
    const tfooter = document.createElement('div');
    // tfooter.classList.add('tabulator-footer');
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
          this.#createLinkCellContent(textCell, rowData, column);
        } else {
          textCell.textContent = column.cell(rowData);
        }
        if (column.type === 'date') {
          this.#createDateCellContent(textCell, rowData, column);
        }
        tr.appendChild(td);
        td.appendChild(textCell);
        // tr.appendChild(this.#createResizeEmptySpace());
        // tr.appendChild(this.#createResizeEmptySpace('prev'));
      });
      if (sub) {
        //добавляется после prepopulate и суммируется
        this.tbody.insertBefore(tr, this.tbody.firstChild);
        if (this.tbody.childElementCount > maxRows) {
          this.tbody.removeChild(this.tbody.lastChild);
        }
      } else {
        this.tbody.appendChild(tr);
      }
    });
  };
  #createDateCellContent(textCell, rowData, column) {
    const result = new Date(column.cell(rowData)).toLocaleString();
    textCell.textContent = result;
  }
  #createLinkCellContent(textCell, rowData, column) {
    const link = document.createElement('a');
    link.setAttribute('target', '_blank');
    link.href = `${column.cell(rowData)}`; // Change  URL
    link.textContent = column.cell(rowData);
    // const ico = document.createElement('i');
    // ico.classList.add('fa', 'fa-sign-in', 'text-success');
    textCell.appendChild(link);
    // td.appendChild(ico);
  }
}
