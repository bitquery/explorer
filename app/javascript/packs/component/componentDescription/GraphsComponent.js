export default class GraphsComponent {
    constructor(element,variables) {
      this.container = element;
      this.config = this.configuration();
      this.variables = variables;
      console.log(variables)
    }
  
    shortenText(text, maxCharCount = 10) {
      return text.length > maxCharCount
        ? `${text.substr(0, maxCharCount)}...`
        : text;
    }
      
    async onData(data, sub) {
      console.log("onData", data);
      const array = this.config.topElement(data);
      
      let nodes = [];
      let edges = [];
      const addresses = new Set();
      for (const rowData of array) {
        let dataObject = {};
        for (const column of this.config.columns) {
          const cellData = column.cell(rowData);
          if(column.name === 'Sender' || column.name === 'Receiver'){
            dataObject[column.name] = cellData;
            if (!addresses.has(cellData)) {
              addresses.add(cellData);
              nodes.push({id: cellData, label: this.shortenText(cellData)});
            }
          }
          if(column.name === 'Time'){
            dataObject[column.name] = cellData;
            if (column.rendering) {
              dataObject[column.name] = await column.rendering(column.cell(rowData)).textContent;
            }
          }
          if(column.name ==='TX Hash'){
            dataObject[column.name] = cellData;
            dataObject[column.name] = column.cell(rowData)
          }
        }
        edges.push({from: dataObject['Sender'], to: dataObject['Receiver'], label: dataObject['Time'], url: `/${variables.networkForURL}/tx/${dataObject['TX Hash']}`});
console.log('edges',edges )
      }
  
      const data2 = {
        nodes: nodes,
        edges: edges
      };
  
      const network = new vis.Network(this.container, data2, this.getOptions());

      network.on('click', function(properties) {
        const edgeId = properties.edges[0];
        if (edgeId) {
            const edge = data2.edges.find(edge => edge.id === edgeId);
            if (edge && edge.url) {
                window.open(edge.url, "_blank");
            }
        }
    });
      
    }
  
    getOptions() {
      return {
        autoResize: true,
        height: '500px' ,
        width: '100%',
        edges:{
          arrows: 'to',
        },
        physics: { 
          barnesHut: {
              gravitationalConstant: -4000,
              centralGravity: 0.1,
              springLength: 95,
              springConstant: 0.01,
          },
        }
      }
    }
  }
  