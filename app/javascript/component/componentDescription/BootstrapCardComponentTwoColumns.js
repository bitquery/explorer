export default class BootstrapCardComponentTwoColumns {
  constructor(element,variables) {
  this.container = element;
  this.config = this.configuration();
  this.variables = variables
  this.createWrapper();
  }

createWrapper() {
  this.wrapper = this.createElementWithClasses('div', 'row', 'row-cols-1', 'row-cols-md-3');
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
  const cardElement = this.createElementWithClasses('div', 'card', 'mb-2');;
  const card = this.createElementWithClasses('div', 'row', 'g-0');
  const [cardImg, cardBodyWrapper] = await this.createCardSections(rowData);
  this.appendChildren(cardElement, card);
  this.appendChildren(card, cardImg, cardBodyWrapper);

  return cardElement;
}

async createCardSections(rowData) {
  const cardImg = this.createElementWithClasses('div',  'd-flex', 'align-items-center', 'col','justify-content-center');
  const cardBodyWrapper = this.createElementWithClasses('div' ,'col');
  const cardBody = this.createElementWithClasses('div',  'card-body','d-flex'); 
  const [leftColumnDiv, rightColumnDiv] = [this.createElementWithClasses('div','col'), this.createElementWithClasses('div', 'col')];
//, 'col-md-6','align-items-start', 'align-items-end'
  for (const column of [...this.config.columnOne, ...this.config.columnTwo]) {
    const cardText = await this.createCardText(column, rowData);

    if (this.config.columnOne.includes(column)) {
      this.appendChildren(leftColumnDiv, cardText)
    } else {
      this.appendChildren(rightColumnDiv, cardText)
    }
  }

  for (const column of this.config.image) {
    if (column.rendering) {
      const imgElement = await column.rendering(column.cell(rowData), this.variables);
      this.appendChildren(cardImg, imgElement)
    }
  }
  this.appendChildren(cardBody,leftColumnDiv,rightColumnDiv);
  this.appendChildren(cardBodyWrapper,cardBody)

  return [cardImg, cardBodyWrapper];
}

async createCardText(column, rowData) {
  const cardText = this.createElementWithClasses('div', 'card-text', 'd-flex','justify-content-start', 'align-items-center', 'col', 'flex-row');
  let spanText;

  if (column.rendering) {
    spanText = await column.rendering(column.cell(rowData),this.variables);
  } else {
    spanText = this.createTextElement('div', column.cell(rowData));
  }
spanText.classList.add('text-truncate')
  const textContainer = this.createElementWithClasses('div', 'text-container', 'text-truncate');
  if(column.name){
      const spanTitle = this.createElementWithClasses('div','text-muted')
      spanTitle.textContent = column.name;
      this.appendChildren(textContainer,spanTitle)
  }

  this.appendChildren(textContainer,spanText)
  this.appendChildren(cardText,textContainer)

  return cardText;
}

createTextElement(elementType, textContent,) {
  const element = document.createElement(elementType);
  element.textContent = textContent;
  return element;
}

appendChildren(parent, ...children) {
  children.forEach(child => parent.appendChild(child));
}

}