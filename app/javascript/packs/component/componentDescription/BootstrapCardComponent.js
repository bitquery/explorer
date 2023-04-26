export default class BootstrapCardComponent {
	constructor(element) {
	  this.container = element;
	  this.config = this.configuration();
	  this.createWrapper();
	}
 
	createWrapper() {
	  this.wrapper = this.createElementWithClasses('div');
	  this.container.appendChild(this.wrapper);
	}
 
	createElementWithClasses(elementType, ...classes) {
	  const element = document.createElement(elementType);
	  element.classList.add(...classes);
	  return element;
	}
 
	onData(data, sub) {
	  console.log('onData', data);
	  const array = this.config.topElement(data);
 
	  array.forEach((rowData) => {
		 const cardElement = this.createElementWithClasses('div', 'card', 'mb-3');
		 const card = this.createElementWithClasses('div', 'row');
		 const cardImg = this.createElementWithClasses('div', 'col-md-4');
		 const cardBodyWrapper = this.createElementWithClasses('div', 'col-md-8');
		 const cardBody = this.createElementWithClasses('div', 'card-body');
		 cardBody.style.display = 'flex';
 
		 const startColumnDiv = this.createElementWithClasses('div', 'col-md-4', 'align-items-start');
		 const endColumnDiv = this.createElementWithClasses('div', 'col-md-8', 'align-items-end');
 
		 this.config.columns.forEach((column) => {
			if (column.name) {
			  const cardTitle = this.createElementWithClasses('div', 'card-title');
			  const span = this.createTextElement('span', column.name);
			  cardTitle.appendChild(span);
			  startColumnDiv.appendChild(cardTitle);
 
			  const cardText = this.createElementWithClasses('div', 'card-title', 'col', 'ellipsis');
			  const spanText = this.createTextElement('span', column.cell(rowData));
			  cardText.appendChild(spanText);
			  endColumnDiv.appendChild(cardText);
			}
		 });
 
		 this.config.columns.forEach(async (column) => {
			const div = await column.rendering(column.cell(rowData));
			cardImg.appendChild(div);
		 });
 
		 this.appendChildren(cardElement, card,cardBodyWrapper);
		 this.appendChildren(card, cardImg, cardBody);
		 this.appendChildren(cardBody, startColumnDiv, endColumnDiv);
		 this.wrapper.appendChild(cardElement);
	  });
	}
 
	createTextElement(elementType, textContent) {
	  const element = document.createElement(elementType);
	  element.textContent = textContent;
	  return element;
	}
 
	appendChildren(parent, ...children) {
	  children.forEach(child => parent.appendChild(child));
	}
 }
 