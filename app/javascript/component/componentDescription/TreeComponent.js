export default class TreeComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
    this.wrapper = this.createElementWithClasses('div')
    this.appendChildren(this.container, this.wrapper);

  }



async onData(data, sub) {
  const allData = this.config.topElement(data);
  this.chainId = this.config.chainId(data);
  const divs = [];
  const divIDs = new Set();
  console.log('allData', allData);

  allData.Calls.forEach(call => {
    divIDs.add(call.Call.Depth);
    console.log(call.Call.Depth);
  });

  divIDs.forEach(id => {
    const div = this.createElementWithClasses('div', 'ml-5');
    div.id = id;
    div.textContent = `${id}`;
    divs[id] = div;
    if (id === 0) {
      this.appendChildren(this.wrapper, div);
    } else {
      this.appendChildren(divs[id - 1], div);
    }
  });

  allData.Calls.forEach(call => {
    const div = this.createElementWithClasses('div', 'ml-5', 'border', 'border-success');
    div.classList.add(call.Call.Index);
    div.textContent = `Signature: ${call.Call.Signature.Signature}`;
    divs[call.Call.Depth].insertBefore(div, divs[call.Call.Depth].firstChild);
  });

  allData.Events.forEach(element => {
    console.log(element.Log.Signature.Signature);
    const div = this.createElementWithClasses('div', 'ml-3', 'text-success');
    div.textContent = `Event: ${element.Log.Signature.Signature}`;
    const targetElement = document.getElementsByClassName(element.Log.LogAfterCallIndex)[0];
    targetElement.appendChild(div);
  });
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