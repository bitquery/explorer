export default class GraphsComponent {
   constructor(element,variables) {
   this.container = element;
   this.config = this.configuration();
   this.variables = variables
   }

   async onData(data, sub) {
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
                      nodes.push({id: cellData, label: cellData});
                  }
              }
              if(column.name === 'Receiver'){
                  Receiver = cellData;
                  if (!addresses[cellData]) {
                      addresses[cellData] = true;
                      nodes.push({id: cellData, label: cellData});
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
  // provide the data in the vis format
     const data2 = {
         nodes: nodes,
         edges: edges
     };
     var options = {
      autoResize: true,
      height: '500px' ,
      width: '100%',
   
      configure: {
         enabled: true,
     
       }
     };
 
     // initialize your network!
     const network = new vis.Network(this.container, data2, options);
   }
}