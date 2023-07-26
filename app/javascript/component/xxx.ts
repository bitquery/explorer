
interface IConfig {
	topElement(data: Data): Partial<Data>,	//which data from full response do we need
	[x: string | number | symbol]: unknown	//any other data that can be required
}


type Payload = {
	query: string,
	variables: object,
	endpoint_url: string
}
interface IDataSource {
	payload: Payload,
	getData(payload: Payload): JSON,
	data?: JSON
}



interface WidgetDataSource {
	setCallback(onData: (data) => void),
	changeVariables(deltaVariables): void
}

/* WIDGET */

class baseWidgetClass {
	container: HTMLElement
	dataSource: object
	subscription: boolean

	constructor(container: HTMLElement, dataSource: WidgetDataSource, ) {
		this.container = container
		this.dataSource = dataSource
	
	}

	initialize() {
		//code to initialize widget/chart/table or anything else
		//get data and prepare it to visualize
		//....?????....
		//PROFIT
	}
}

class specificWidgetClass extends baseWidgetClass {
	config: IConfig
	configuration: () => IConfig

	constructor(container: HTMLElement, dataSource: IDataSource) {
		super(container, dataSource)
		
		this.config = this.configuration() 
	}

	
}

/* WIDGET */
