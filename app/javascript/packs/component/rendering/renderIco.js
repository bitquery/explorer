export default function renderIco(nameIco){
   const i = document.createElement('i')
   const icons = {
      sender: 'fa fa-sign-in text-success',
      receiver: 'fas fa-share-square text-primary',
   }
   i.className = icons[nameIco];
   return i
}