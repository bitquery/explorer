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
        content: JSON.stringify(mediaData),
      },
    ];
  }
  const accordion = document.createElement('div');

  accordion.classList.add('accordion');
  accordion.id = 'accordionExample';

  mediaData.forEach(item => {
    const accordionItem = document.createElement('div');
    accordionItem.classList.add('accordion-item', 'd-flex','align-items-center');

    const accordionHeader = document.createElement('div');
    accordionHeader.classList.add('accordion-header');
    accordionHeader.style.cursor = 'pointer'
    accordionHeader.textContent = item.header;

    
    const accordionContent = document.createElement('div');
    accordionContent.classList.add('accordion-content');
    accordionContent.textContent = item.content;
    
    accordionContent.style.display = 'none';
    const span = document.createElement('div')
    span.classList.add('fa', 'fa-caret-down')
    const i = document.createElement('i')
    span.appendChild(i);
    accordionItem.style.gap = '10px';
    accordionHeader.style.userSelect = 'none'
    accordionContent.style.whiteSpace = 'pre-wrap'
    accordionContent.style.overflowWrap = 'anywhere'
    accordionItem.appendChild(span);
    accordionItem.appendChild(accordionHeader);
    accordionItem.appendChild(accordionContent);

    accordion.appendChild(accordionItem);
  });

  accordion.addEventListener('click', (event) => {
    if (event.target.classList.contains('accordion-header')) {
      const accordionContent = event.target.nextElementSibling;
      const accordionHeader = document.querySelector('accordion-header')
      if (accordionContent.style.display === 'block') {
        accordionContent.style.display = 'none';
        accordionHeader.style.writingMode = 'horizontal-tb';
      } else {
        accordionContent.style.display = 'block';
        accordionHeader.style.writingMode = 'vertical-lr';
      }
    }
  });


  return accordion;
}
