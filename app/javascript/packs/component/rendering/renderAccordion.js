export default async function renderAccordion(uri) {
   const url = uri.startsWith('ipfs://') ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;
   const accordionId = 'myAccordion';
 
   const mediaData = await fetchMediaURL(url);
 
   async function fetchMediaURL(url) {
     let mediaDescription, mediaData;
 
     if (/^http/.test(url)) {
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
 
   const accordion = document.createElement('div');
   accordion.classList.add('accordion');
   // accordion.id = accordionId;
 
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
     accordion.appendChild(itemElement);
   // });
 
   return accordion;
 }
 