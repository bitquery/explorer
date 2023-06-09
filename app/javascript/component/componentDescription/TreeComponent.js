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
  const depths = [];
  console.log('allData', allData);
const dataForTree = [

]
  allData.Calls.forEach(call => {
    if (!depths.includes(call.Call.Depth)) {
      depths.push(call.Call.Depth);
      const div = this.createElementWithClasses('div', 'ml-5', "container-tree");
      div.id = call.Call.Depth;
      // div.style.height = '40px'
      divs[call.Call.Depth] = divs[call.Call.Depth] || div;
      if (call.Call.Depth === 0 || depths.length === 1) {
        this.appendChildren(this.wrapper, div);
      } else {
        this.appendChildren(divs[depths[depths.length - 2]], div);
      }
    div.addEventListener('click', function(e) {
      if(!this.classList.contains('show-tree')){

        this.classList.add('show-tree');
      }else {
          this.classList.remove('show-tree');
      }
    });

    }
    const callDiv = this.createElementWithClasses('div', 'ml-5',call.Call.Index,'line-tree');
    // callDiv.classList.add(call.Call.Index);
    callDiv.textContent = `Signature: ${call.Call.Signature.Signature} , Index: ${call.Call.Index} EnterIndex: ${call.Call.EnterIndex} ExitIndex: ${call.Call.ExitIndex} `;
    divs[call.Call.Depth].appendChild(callDiv);
  })

  allData.Events.forEach(element => {
    console.log(element.Log.Signature.Signature);
    const div = this.createElementWithClasses('div', 'ml-3', 'text-success');
    div.textContent = `Event: ${element.Log.Signature.Signature} EnterIndex: ${element.Log.EnterIndex} Index: ${element.Log.Index} ExitIndex: ${element.Log.ExitIndex} LogAfterCallIndex: ${element.Log.LogAfterCallIndex}`;
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