export default class BootstrapCardComponentTwoColumns {
	constructor(element) {
	  this.container = element;
	  this.config = this.configuration();
	  this.createWrapper();
	}
 
	createWrapper() {
	  this.wrapper = this.createElementWithClasses('div', 'd-flex', 'flex-wrap', 'justify-content-around');
	  this.container.appendChild(this.wrapper);
	}
 
	createElementWithClasses(elementType, ...classes) {
	  const element = document.createElement(elementType);
	  element.classList.add(...classes);
	  return element;
	}
 
	async onData(data, sub) {
		const array = this.config.topElement(data);
		const maxRows = 10;
		const cardPromises = array.map(async (rowData) => {
		  const cardElement = await this.createCardElement(rowData);
		  if (sub) {
			 this.wrapper.insertBefore(cardElement, this.wrapper.firstChild);
			 if (this.wrapper.childElementCount > maxRows) {
				this.wrapper.removeChild(this.wrapper.lastChild);
			 }
		  } else {
			 this.wrapper.appendChild(cardElement);
		  }
		});
	 
		await Promise.all(cardPromises);
	 }
	 
 
	 async createCardElement(rowData) {
	  const cardElement = this.createCardWrapper();
	  cardElement.style.width = '800px'
	  const card = this.createCardBody();
	  const [cardImg, cardBodyWrapper] = await this.createCardSections(rowData);
	  this.appendChildren(cardElement, card);
	  this.appendChildren(card, cardImg, cardBodyWrapper);
 
	  return cardElement;
	}
 
	createCardWrapper() {
	  return this.createElementWithClasses('div', 'card', 'mb-3');
	}
 
	createCardBody() {
	  return this.createElementWithClasses('div', 'row', 'g-0');
	}
 
	async createCardSections(rowData) {
		const cardImg = this.createElementWithClasses('div', 'col-md-3', 'd-flex', 'align-items-center');
		const cardBodyWrapper = this.createElementWithClasses('div', 'col-md-9');
		const cardBody = this.createElementWithClasses('div', 'card-body', 'd-flex');
		const startColumnDiv = this.createElementWithClasses('div', 'col-md-6', 'align-items-start');
		const endColumnDiv = this.createElementWithClasses('div', 'col-md-6', 'align-items-end');
	 
		await Promise.all(
		  this.config.column1.map(async (column) => {
			 const cardText = await this.createCardText(column, rowData);
			 startColumnDiv.appendChild(cardText);
		  })
		);
	 
		await Promise.all(
		  this.config.column2.map(async (column) => {
			 const cardText = await this.createCardText(column, rowData);
			 endColumnDiv.appendChild(cardText);
		  })
		);
	 
		await Promise.all(
		  this.config.image.map(async (column) => {
			 if (column.rendering) {
				const imgElement = await column.rendering(column.cell(rowData));
				cardImg.appendChild(imgElement);
			 }
		  })
		);
	 
		cardBody.appendChild(startColumnDiv);
		cardBody.appendChild(endColumnDiv);
		cardBodyWrapper.appendChild(cardBody);
	 
		return [cardImg, cardBodyWrapper];
	 }
	 
  async createCardText(column, rowData) {
		const cardText = this.createElementWithClasses('div', 'card-title', 'd-flex', 'justify-content-start', 'align-items-center', 'col', 'flex-row', 'gap-10');
		cardText.style.gap = '10px'
		let spanText;
		if (column.ico) {
		  cardText.appendChild(renderIco(column.ico));
		}
		if (column.rendering) {
			spanText = await column.rendering(column.cell(rowData));
		 } else {
			spanText = this.createTextElement('div', column.cell(rowData));
		 }
		if (column.cell.name === "renderAccordion") {
		  cardText.appendChild(spanText);
		} else {
		  const textContainer = this.createElementWithClasses('div', 'text-container');
		  textContainer.appendChild(spanText);
		  cardText.appendChild(textContainer);
	 
		  textContainer.style.display = 'block';
		  textContainer.style.width = '100%';
		  textContainer.style.whiteSpace = 'nowrap';
		  textContainer.style.overflow = 'hidden';
		  textContainer.style.textOverflow = 'ellipsis';
		}
	 
		return cardText;
	 }
	 
  
	 createTextElement(elementType, textContent, readyElement) {
		if (readyElement) {
		  return readyElement;
		}
		const element = document.createElement(elementType);
		element.textContent = textContent;
		return element;
	 }
  
	 appendChildren(parent, ...children) {
		children.forEach(child => parent.appendChild(child));
	 }

	 
  }
  