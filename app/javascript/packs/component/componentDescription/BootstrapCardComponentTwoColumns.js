export default class BootstrapCardComponentTwoColumns {
	constructor(element) {
		this.container = element;
		this.config = this.configuration();
		this.createWrapper();
		
		
	}

	createWrapper() {
		this.wrapper = this.createElementWithClasses('div');
		this.wrapper.style.display = 'flex'
		this.wrapper.style.flexWrap = 'wrap'
		this.wrapper.style.justifyContent = 'space-around'
		this.container.appendChild(this.wrapper);
	}

	createElementWithClasses(elementType, ...classes) {
		const element = document.createElement(elementType);
		element.classList.add(...classes);
		return element;
	}

	 async onData(data, sub) {
		console.log('onData', data);
		const array = this.config.topElement(data);
		console.log('array from onData',array)
		const maxRows = 10;

		array.forEach(async (rowData) => {
			const cardElement = this.createElementWithClasses('div', 'card', 'mb-3');
			const card = this.createElementWithClasses('div', 'row', 'g-0');
			cardElement.style.minWidth = '80%'
			const cardImg = this.createElementWithClasses('div', 'col-md-3');
			cardImg.style.display = 'flex';
			cardImg.style.alignItems = 'center';

			const cardBodyWrapper = this.createElementWithClasses('div', 'col-md-9');
			const cardBody = this.createElementWithClasses('div', 'card-body');
			cardBody.style.display = 'flex';

			const startColumnDiv = this.createElementWithClasses('div', 'col-md-6', 'align-items-start');
			const endColumnDiv = this.createElementWithClasses('div', 'col-md-6', 'align-items-end');
			this.config.column1.forEach((column) => {
				if (column.rendering) {
					const cardText = this.createElementWithClasses('div', 'card-title','d-flex', 'justify-content-start', 'align-items-center', 'col','flex-row');
					cardText.style.gap = '10px'			
					const spanText = column.rendering(column.cell(rowData));
					if (column.ico) {
						const ico = renderIco(column.ico);
						cardText.appendChild(ico);
					}
					cardText.appendChild(spanText);
					startColumnDiv.appendChild(cardText);
				} else {
					const cardText = this.createElementWithClasses('div', 'card-title','d-flex', 'justify-content-start', 'align-items-center', 'col','flex-row');
					cardText.style.gap = '10px'
					const spanText = this.createTextElement('div', column.cell(rowData));
					cardText.appendChild(spanText);
					startColumnDiv.appendChild(cardText);
				}
			});
			this.config.column2.forEach((column) => {
				if (column.rendering) {
					const cardText = this.createElementWithClasses('div', 'card-title','d-flex', 'justify-content-start', 'align-items-center', 'col','flex-row');
					cardText.style.gap = '10px'
					const spanText = column.rendering(column.cell(rowData)); 
					if (column.ico) {
						const ico = renderIco(column.ico);
						cardText.appendChild(ico);
					}
					cardText.appendChild(spanText);
					endColumnDiv.appendChild(cardText);
				} else {
					const cardText = this.createElementWithClasses('div', 'card-title','d-flex', 'justify-content-start', 'align-items-center', 'col','flex-row');
					cardText.style.gap = '10px'
						const spanText = this.createTextElement('div', column.cell(rowData));
						cardText.appendChild(spanText);
						endColumnDiv.appendChild(cardText);
				  }
			 });
			 this.config.image.forEach(async (column) => {
				  if (column.rendering) {
						const div = await column.rendering(column.cell(rowData));
						cardImg.appendChild(div);
				  }
			 });
			 this.appendChildren(cardElement, card);
			 this.appendChildren(card, cardImg, cardBodyWrapper);
			 this.appendChildren(cardBodyWrapper, cardBody);
			 this.appendChildren(cardBody, startColumnDiv, endColumnDiv);
			 if (sub) {
				  this.wrapper.insertBefore(cardElement, this.wrapper.firstChild)
				  if (this.wrapper.childElementCount > maxRows) {
						this.wrapper.removeChild(this.wrapper.lastChild);
				  }
			 } else {
				  this.wrapper.appendChild(cardElement);
			 }
			
		});
  }
  

	createTextElement(elementType, textContent, readyElement) {
		if(readyElement){
			return readyElement
		}
		const element = document.createElement(elementType);
		element.textContent = textContent;
		return element;
	}

	appendChildren(parent, ...children) {
		children.forEach(child => parent.appendChild(child));
	}
}
