import Tabulator from "tabulator-tables"; 
import "./assets/css/index.css"
// import { formatter } from "./utils/formatter.js";

export default async function tableWidgetRenderer(ds, config, el) {
	let values = undefined
	let cfg = {}
	if (!ds.values) {
		const data = await ds.fetcher()
		const json = await data.json()
		console.log(json)
		values = ds.setupData(json)
	} else {
		values = ds.values
	}
	console.log(values)
	// let newCol = [...config.columns]
	// newCol.forEach(col => col.formatter = col.formatterParams && formatter)
	cfg = {
		height: '100%',
		layout: 'fitData',
		...config,
		data: values,
	}
	
		try {
			if (el) {
				const table = new Tabulator(`#${el}`, cfg)
				return table
			}
		} catch (error) {
			console.log(error)
		}
	
}