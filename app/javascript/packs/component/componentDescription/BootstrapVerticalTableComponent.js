export default class BootstrapTableComponent {
		constructor(element,variables) {
			 this.container = element;
			 this.config = this.configuration();
			 this.variables = variables
			 this.createWrapper();
			 this.createTable();
		}
  
		createWrapper() {
			 this.wrapper = this.createElementWithClasses("div", "table-responsive-md");
			 this.appendChildren(this.container, this.wrapper);
		}
  
		createTable() {
			 this.tableElement = this.createElementWithClasses(
				  "table",
				  "table",
				  'table-sm',
				  "table-striped",
				  "table-hover"
			 );
			 this.tableElement.style.tableLayout = 'fixed';
			 this.appendChildren(this.wrapper, this.tableElement);
			 this.createThead();
			 this.createTbody();
			 this.createTfooter();
		}
  
		createThead() {
			 const thead = this.createElementWithClasses("thead");
			 const tr = this.createElementWithClasses("tr");
			 this.appendChildren(this.tableElement, thead);
			 this.appendChildren(thead, tr);
  
			 const th1 = this.createElementWithClasses("th");
			 th1.setAttribute("scope", "row");
			 th1.textContent = 'Property';
			 this.appendChildren(tr, th1);
  
			 const th2 = this.createElementWithClasses("th");
			 th2.setAttribute("scope", "row");
			 th2.textContent = 'Value';
			 this.appendChildren(tr, th2);
		}
  
		createTbody() {
			 this.tbody = this.createElementWithClasses("tbody");
			 this.appendChildren(this.tableElement, this.tbody);
		}
  
		createTfooter() {
			 const tfooter = this.createElementWithClasses("div");
			 this.appendChildren(this.tableElement, tfooter);
		}
  
		async onData(data, sub) {
			 console.log("onData", data);
			 const array = this.config.topElement(data);
			 const maxRows = 15;
			 for (const rowData of array) {
				  for (const column of this.config.columns) {
						const tr = this.createElementWithClasses("tr");
  
						const td1 = this.createElementWithClasses("td");
						const textCell1 = this.createElementWithClasses("span",'text-info', 'font-weight-bold');
						textCell1.textContent = column.name;
						this.appendChildren(td1, textCell1);
  
						const td2 = this.createElementWithClasses("td");
						const textCell2 = this.createElementWithClasses("span");
						textCell2.textContent = column.cell(rowData);
						this.appendChildren(td2, textCell2);
  
						if (column.rendering) {
							 const div = await column.rendering(column.cell(rowData),this.variables);
							 td2.replaceChild(div, textCell2);
						}
  
						this.appendChildren(tr, td1, td2);
  
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
