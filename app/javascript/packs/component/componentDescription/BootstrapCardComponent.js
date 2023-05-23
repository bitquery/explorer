export default class BootstrapCardComponent {
    constructor(element,variables) {
      this.container = element;
      this.config = this.configuration();
      this.variables = variables
      this.createWrapper();
    }
  
    createWrapper() {
      this.wrapper = this.createElementWithClasses('div', 'card-columns');
      this.container.appendChild(this.wrapper);
    }
  
    createElementWithClasses(elementType, ...classes) {
      const element = document.createElement(elementType);
      element.classList.add(...classes);
      return element;
    }
  
    async onData(data, sub) {
      // console.log(data)
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
      const cardElement = this.createElementWithClasses('div', 'card', 'xl-2', 'no-gutters');
      const card = this.createElementWithClasses('div', 'row', 'g-0', 'no-gutters');
      const [cardImg, cardBody] = await this.createCardSections(rowData);
      this.appendChildren(cardElement, card);
      this.appendChildren(card, cardImg, cardBody);
  
      return cardElement;
    }
  
    async createCardSections(rowData) {
      const cardImg = this.createElementWithClasses('div', 'col','no-gutters','col-md-4');
      
      const cardBody = this.createElementWithClasses('div',  'card-body','no-gutters','row','col-md-8'); 
      const [leftColumnDiv, rightColumnDiv] = [this.createElementWithClasses('div','col', 'no-gutters'), this.createElementWithClasses('div', 'col', 'no-gutters')];
  
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
  
      this.appendChildren(cardBody, leftColumnDiv, rightColumnDiv);
  
      return [cardImg, cardBody];
    }
  
    async createCardText(column, rowData) {
      const cardText = this.createElementWithClasses('div', 'card-text','no-gutters' );
      cardText.style.maxWidth = '150px'
      let spanText;
      if (column.rendering) {
        spanText = await column.rendering(column.cell(rowData), this.variables);
      } else {
        spanText = this.createTextElement('div', column.cell(rowData));
      }
      
      spanText.classList.add('text-truncate')
      spanText.style.maxWidth = '150px'
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
  