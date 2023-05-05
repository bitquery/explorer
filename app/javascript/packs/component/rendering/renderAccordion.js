export default async function renderAccordion(uri) {
  const url = uri.startsWith('ipfs://') ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;

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
      console.log('error in accordion fetch');
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
  const uniqueId = Math.random().toString(36).substr(2, 9);
  const accordionId = `accordionFlushExample-${uniqueId}`;

  const accordion = document.createElement('div');
  accordion.setAttribute('class', 'accordion accordion-flush');
  accordion.setAttribute('id', accordionId);

  mediaData.forEach((item, index) => {
    const itemId = `${accordionId}-item-${index + 1}`;

    const accordionItem = document.createElement('div');
    accordionItem.setAttribute('class', 'accordion-item');

    const accordionHeader = document.createElement('h5');
    accordionHeader.setAttribute('class', 'accordion-header');
    accordionHeader.setAttribute('id', `${itemId}-header`);

    const accordionButton = document.createElement('button');
    accordionButton.setAttribute('class', 'accordion-button collapsed');
    accordionButton.setAttribute('type', 'button');
    accordionButton.setAttribute('data-bs-toggle', 'collapse');
    accordionButton.setAttribute('data-bs-target', `#${itemId}-collapse`);
    accordionButton.setAttribute('aria-expanded', 'false');
    accordionButton.setAttribute('aria-controls', `${itemId}-collapse`);
    accordionButton.textContent = item.header;

    accordionHeader.appendChild(accordionButton);

    const accordionCollapse = document.createElement('div');
    accordionCollapse.setAttribute('id', `${itemId}-collapse`);
    accordionCollapse.setAttribute('class', 'accordion-collapse collapse');
    accordionCollapse.setAttribute('aria-labelledby', `${itemId}-header`);
    accordionCollapse.setAttribute('data-bs-parent', `#${accordionId}`);

    const accordionBody = document.createElement('div');
    accordionBody.setAttribute('class', 'accordion-body');
    accordionBody.textContent = item.content;

    accordionCollapse.appendChild(accordionBody);

    accordionItem.appendChild(accordionHeader);
    accordionItem.appendChild(accordionCollapse);

    accordion.appendChild(accordionItem);
  });

  return accordion;
}
