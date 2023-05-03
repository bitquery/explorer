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
         header: 'Description',
         content: mediaDescription,
       },
       {
         header: 'Data',
         content: JSON.stringify(mediaData, null, 2),
       },
     ];
   }
   console.log('mediaData',mediaData)
   const accordion = document.createElement('div');
   accordion.style.zIndex = '100000'
   accordion.classList.add('accordion');
   accordion.id = 'accordionExample';
  
      mediaData.forEach(item => {
       const accordionItem = document.createElement('div');
       accordionItem.classList.add('accordion-item');

       const accordionHeader = document.createElement('div');
       accordionHeader.classList.add('accordion-header');
       accordionHeader.style.cursor = 'pointer'
       accordionHeader.textContent = item.header;
       accordionItem.appendChild(accordionHeader);

       const accordionContent = document.createElement('div');
       accordionContent.classList.add('accordion-content');
       accordionContent.innerHTML = item.content;
       accordionItem.appendChild(accordionContent);
       accordionContent.style.display = 'none';

       accordion.appendChild(accordionItem);
   });

   accordion.addEventListener('click', (event) => {
       if (event.target.classList.contains('accordion-header')) {
           const accordionContent = event.target.nextElementSibling;
           if (accordionContent.style.display === 'block') {
               accordionContent.style.display = 'none';
           } else {
               accordionContent.style.display = 'block';
           }
       }
   });


   return accordion;
 }
 