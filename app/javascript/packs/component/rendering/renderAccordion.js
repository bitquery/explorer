export default async function renderAccordion(uri) {
   const url = uri.startsWith('ipfs://') ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;
 
   const mediaData = await fetchMediaData(url);
 
   async function fetchMediaData(url) {
     let mediaDescription, mediaData;
 
     if (url.startsWith('http')) {
       const response = await fetch(url);
       const data = await response.json();
       mediaData = data;
       mediaDescription = data.description;
     } else if (url.startsWith('data:application/json')) {
       const base64Data = url.replace('data:application/json;base64,', '');
       const json = JSON.parse(atob(base64Data));
       mediaDescription = json.description;
       mediaData = json;
     }
 
     return [
       {
         title: 'Description',
         content: mediaDescription,
       },
       {
         title: 'Data',
         content: JSON.stringify(mediaData, null, 2),
       },
     ];
   }
   console.log('mediaData',mediaData)
   const accordion = document.createElement('div');
   accordion.classList.add('accordion');
   accordion.id = 'accordionExample';
   mediaData.forEach((e, index) =>{

   const itemElement1 = document.createElement('div');
   itemElement1.classList.add('accordion-item');
   const headerElement1 = document.createElement('h5');
   headerElement1.classList.add('accordion-header');
   headerElement1.id = 'headingOne';
   const buttonTitle1 = document.createElement('button');
   buttonTitle1.classList.add('accordion-button');
   buttonTitle1.setAttribute('type', 'button');
   buttonTitle1.setAttribute('data-bs-toggle', 'collapse');
   buttonTitle1.setAttribute('data-bs-target', '#collapseOne');
   buttonTitle1.setAttribute('aria-expanded', 'false');
   buttonTitle1.setAttribute('aria-controls', 'collapseOne');
   buttonTitle1.textContent = e.title;
   const collapseOne = document.createElement('div');
   collapseOne.id='collapseOne';
   collapseOne.classList.add('accordion-collapse','collapse')
   collapseOne.setAttribute('aria-labelledby','headingOne')
   collapseOne.setAttribute('data-bs-parent','#accordionExample')
   const collapseOneBody = document.createElement('div');
   collapseOneBody.classList.add('accordion-body');
   collapseOneBody.textContent = e.content

   headerElement1.appendChild(buttonTitle1);
   collapseOne.appendChild(collapseOneBody)
   headerElement1.appendChild(collapseOne);
   itemElement1.appendChild(headerElement1);
   accordion.appendChild(itemElement1)
})

   // mediaData.forEach((item, index) => {
   //   const itemId = `${accordionId}-item-${index}`;
 
   //   const itemElement = document.createElement('div');
   //   itemElement.classList.add('accordion-item');
 
   //   const headerElement = document.createElement('h2');
   //   headerElement.classList.add('accordion-header');
   //   headerElement.id = `${itemId}-header`;
 
   //   const buttonElement = document.createElement('button');
   //   buttonElement.classList.add('accordion-button', 'collapsed');
   //   buttonElement.setAttribute('type', 'button');
   //   buttonElement.setAttribute('data-bs-toggle', 'collapse');
   //   buttonElement.setAttribute('data-bs-target', `#${itemId}`);
   //   buttonElement.setAttribute('aria-expanded', 'false');
   //   buttonElement.setAttribute('aria-controls', itemId);
   //   buttonElement.textContent = item.title;
 
   //   const collapseElement = document.createElement('div');
   //   collapseElement.classList.add('accordion-collapse', 'collapse');
   //   collapseElement.id = itemId;
   //   collapseElement.setAttribute('aria-labelledby', `${itemId}-header`);
   //   collapseElement.setAttribute('data-bs-parent', `#${accordionId}`);
 
   //   const bodyElement = document.createElement('div');
   //   bodyElement.classList.add('accordion-body');
   //   bodyElement.innerHTML = item.content;
 
   //   headerElement.appendChild(buttonElement);
   //   collapseElement.appendChild(bodyElement);
   //   itemElement.appendChild(headerElement);
   //   itemElement.appendChild(collapseElement);
   //   accordion.appendChild(itemElement);
   // });
 
   return accordion;
 }
 