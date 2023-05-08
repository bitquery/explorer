
export default class BootstrapCardComponentTwoColumns {
  constructor(element) {
  this.container = element;
  this.config = this.configuration();
  this.createWrapper();
  }

createWrapper() {
  this.wrapper = this.createElementWithClasses('div','row' ,'row-cols-1', 'row-cols-md-2');
  this.container.appendChild(this.wrapper);
}

createElementWithClasses(elementType, ...classes) {
  const element = document.createElement(elementType);
  element.classList.add(...classes);
  return element;
}

async onData(data, sub) {
  console.log(data)
  const array = this.config.topElement(data);
  const maxRows = 10;

   for (const rowData of array) {
    const cardElement = await this.createCardElement(rowData);
    if (sub) {
        this.wrapper.insertBefore(cardElement, this.wrapper.firstChild);
        if (this.wrapper.childElementCount > maxRows) {
            this.wrapper.removeChild(this.wrapper.lastChild);
        }
    } else {
        this.wrapper.appendChild(cardElement);
    }
}
}

async createCardElement(rowData) {
  const cardElement = this.createCardWrapper();
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
  const cardImg = this.createElementWithClasses('div', 'col-md-3', 'd-flex', 'align-items-center', 'justify-content-center');
  const cardBodyWrapper = this.createElementWithClasses('div', 'col-md-9');
  const cardBody = this.createElementWithClasses('div', 'card-body', 'd-flex');
  const startColumnDiv = this.createElementWithClasses('div','col-md-6',  'align-items-start');
  const endColumnDiv = this.createElementWithClasses('div', 'col-md-6','align-items-end');
  
  for (const column of this.config.column1) {
    const cardText = await this.createCardText(column, rowData);
    startColumnDiv.appendChild(cardText);
  }

  for (const column of this.config.column2) {
    const cardText = await this.createCardText(column, rowData);
    endColumnDiv.appendChild(cardText);
 }

  for (const column of this.config.image) {
    if (column.rendering) {
        const imgElement = await column.rendering(column.cell(rowData));
        cardImg.appendChild(imgElement);
    }
  };

  cardBody.appendChild(startColumnDiv);
  cardBody.appendChild(endColumnDiv);
  cardBodyWrapper.appendChild(cardBody);

  return [cardImg, cardBodyWrapper];
}

async createCardText(column, rowData) {
  const cardText = this.createElementWithClasses('div', 'card-text', 'd-flex', 'justify-content-start', 'align-items-center', 'col', 'flex-row');
  cardText.style.gap = '10px'
  let spanText;

  if (column.rendering) {
    spanText = await column.rendering(column.cell(rowData));
  } else {
    spanText = this.createTextElement('div', column.cell(rowData));
  }

    const textContainer = this.createElementWithClasses('div', 'text-container', 'text-truncate');
    if(column.name){
        const spanTitle = this.createElementWithClasses('div','text-muted')
        spanTitle.textContent = column.name;
        textContainer.appendChild(spanTitle);
        
    }
    textContainer.appendChild(spanText);
    cardText.appendChild(textContainer);
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