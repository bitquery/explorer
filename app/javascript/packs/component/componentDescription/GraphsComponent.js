export default class GraphsComponent {
   constructor(element,variables) {
   this.container = element;
   this.config = this.configuration();
   this.variables = variables
   }


  
   async onData(data, sub) {
    function shorten(text, maxCharCount = 10) {
        if (text.length > maxCharCount) {
          return text.substr(0, maxCharCount) + '...';
        } else {
          return text;
        }
      }
      console.log("onData", data);
      const array = this.config.topElement(data);
      
      let nodes = [];
      let edges = [];
      const addresses = new Set();
      for (const rowData of array) {
          let Sender, Receiver, Time;
          for (const column of this.config.columns) {
              const cellData = column.cell(rowData);
              if(column.name === 'Sender'){
                  Sender = cellData;
                  if (!addresses[cellData]) {
                      addresses[cellData] = true;
                      nodes.push({id: cellData, label: shorten(cellData)});
                  }
              }
              if(column.name === 'Receiver'){
                  Receiver = cellData;
                  if (!addresses[cellData]) {
                      addresses[cellData] = true;
                      nodes.push({id: cellData, label: shorten(cellData)});
                  }
              }
              if(column.name === 'Time'){
                 Time = cellData;
               if (column.rendering) {
                  Time = await column.rendering(column.cell(rowData)).textContent;
                }
                
              }
          }
   
          edges.push({from: Sender, to: Receiver, label: Time});
      }

     const data2 = {
         nodes: nodes,
         edges: edges
     };

    var options = {
      autoResize: true,
      height: '500px' ,
      width: '100%',
      edges:{
        arrows: 'to',
      },
    //   nodes:{
    //     level: 5,
    //     shape: 'ellipse',
    //     // size:20,
    //   },
    //   layout: {
    //     improvedLayout: true,
   
    //   }
      physics: { 
        hierarchicalRepulsion: {
            centralGravity: 0.3,
            springLength: 500,
            springConstant: 0.01,
            nodeDistance: 120,
          },
  }
    }   
     // initialize your network!
     const network = new vis.Network(this.container, data2, options);
   }
}