export default async function renderDropdown(uri) {
   const url = uri.startsWith('ipfs://')
     ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/')
     : uri;
 
   const mediaData = await fetchMediaData(url);
 
   async function fetchMediaData(url) {
     let mediaDescription, mediaData;
     try {
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
     } catch {
       console.log('error in dropdown fetch');
     }
 
     return [
       {
         title: 'Description',
         content: mediaDescription,
       },
       {
         title: 'Data',
         content: JSON.stringify(mediaData),
       },
     ];
   }
 
   const dropdownContainer = document.createElement('div');
   dropdownContainer.setAttribute('class', 'dropdown-container d-flex');
 
   mediaData.forEach((item, index) => {
     const uniqueId = Math.random().toString(36).substr(2, 9);
     const dropdownMenuId = `dropdownMenu-${uniqueId}`;
 
     const dropdown = document.createElement('div');
     dropdown.setAttribute('class', 'dropdown');
 
     const dropdownButton = document.createElement('button');
     dropdownButton.setAttribute('class', 'btn btn-secondary dropdown-toggle');
     dropdownButton.setAttribute('type', 'button');
     dropdownButton.setAttribute('id', dropdownMenuId);
     dropdownButton.setAttribute('data-bs-toggle', 'dropdown');
     dropdownButton.setAttribute('aria-expanded', 'false');
     dropdownButton.textContent = item.title;
 

     const dropdownMenu = document.createElement('ul');
     dropdownMenu.setAttribute('class', 'dropdown-menu');
     dropdownMenu.setAttribute('aria-labelledby', dropdownMenuId);
 
     const dropdownItem = document.createElement('li');
 
     const dropdownLink = document.createElement('a');
     dropdownLink.setAttribute('class', 'dropdown-item');
     dropdownLink.setAttribute('href', '#');
     dropdownLink.textContent = item.content;
     dropdownLink.addEventListener('click', (e) => {
       e.preventDefault();
       e.textContent = item.content;
     });
     
     dropdownItem.appendChild(dropdownLink);
     dropdownMenu.appendChild(dropdownItem);
     dropdown.appendChild(dropdownButton);
     dropdown.appendChild(dropdownMenu);
     dropdownContainer.appendChild(dropdown);

   });
 
   return dropdownContainer;
 }
 