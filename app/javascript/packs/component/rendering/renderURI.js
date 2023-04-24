async function createAccordionItem(item, index) {
	const accordionItem = document.createElement('div');
	accordionItem.classList.add('accordion-item');
	return accordionItem;
}

export default async function renderURI(uri) {
	const accordion = document.createElement('div');
	accordion.id = 'accordionExample';

	const url = uri.startsWith('ipfs://') ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;

	const response = await fetch(url);
	const data = await response.json();
	console.log('data from accordion', data);
	data.forEach(async (item, i) => {
		const accordionItem = await createAccordionItem(item, i);
		accordion.appendChild(accordionItem);
	});

	return accordion;
}
