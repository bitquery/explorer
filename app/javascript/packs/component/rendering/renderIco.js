export default function renderIco(nameIco){
   const span = document.createElement('div')
   span.classList.add('d-flex', 'd-inline-flex')
   const i = document.createElement('i')
   const icons = {
      sender: 'fa fa-sign-in text-success',
      receiver: 'fas fa-share-square text-primary',
   }
   i.className = icons[nameIco];

   span.appendChild(i)
   return span
}