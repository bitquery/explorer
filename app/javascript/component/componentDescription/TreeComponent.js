export default class TreeComponent {
  constructor(element, variables) {
    this.container = element;
    this.config = this.configuration();
    this.variables = variables;
  }

  async onData(data, sub) {
    const allData = this.config.topElement(data);
    this.chainId = this.config.chainId(data);
    console.log('allData', allData);
  
  
    var tree = new TreeView(
      [
        {name: 'Item 1', children: []},
        {
          name: 'Item 2',
          expanded: true,
          children: [
            {name: 'Sub Item 1', children: []},
            {name: 'Sub Item 2', children: []},
          ],
        },
      ],
      this.container
    );
    tree.on('select', function (e) {
      console.log(JSON.stringify(e));
    });

      allData.Calls.forEach(e=>{

      })

  }
}
