export default async function renderImgFromURI(uri) {
  function createContainer() {
    const div = document.createElement('div');
    div.style.cursor = 'pointer';
    // div.style.background = 'green';
    // div.style.contain = '';
    return div;
  }

  function preprocessURI(uri) {
    return /^ipfs:\/\//.test(uri) || /^ipfs:\/\//.test(uri) ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;
  }

  async function fetchMediaURL(url) {
    let mediaURL, nameMedia;

    if (/^http/.test(url)) {
      const response = await fetch(url);
      const data = await response.json();
      mediaURL = data.image || data.image_url || data.image_data;
      nameMedia = data.name;
    } else if (url.startsWith('data:application/json')) {
      const base64Data = url.replace('data:application/json;base64,', '');
      const json = JSON.parse(atob(base64Data));
      mediaURL = json.image || json.image_url || json.image_data;
      nameMedia = json.name;
    }

    if (mediaURL && mediaURL.startsWith('ipfs://')) {
      mediaURL = mediaURL.replace(/^ipfs:\/\//, 'https://ipfs.io/ipfs/');
    }
    console.log('mediaURL', mediaURL);
    console.log('url', url);
    return {mediaURL, name: nameMedia};
  }

  function appendMediaElement(container, mediaURL) {
    const mediaElement = createMediaElement(mediaURL.mediaURL);
    container.appendChild(mediaElement);
    addClickListener(container, mediaURL.mediaURL);

    // const span = document.createElement('span');
    // span.classList.add('text-smal')
    // span.textContent = mediaURL.name;
    // container.appendChild(span);
  }

  const appendErrorElement= (container, url)=> {
    const span = document.createElement('span');
    span.textContent = 'No data'; //JSON.stringify(url);'No data';
    container.appendChild(span);
  }

  function createMediaElement(src) {
    const div = document.createElement('div');
    div.classList.add('col')
    const mediaElement = /\.(mp4|mov|webm)$/.test(src) ? createVideoElement(src) : createImageElement(src);
    // let mediaElement;
    // if (/\.(mp4|mov|webm)$/.test(src)) {
    //   mediaElement = createVideoElement(src);
    // }
    // if (/\.(jpeg|jpg|png|gif|bmp|svg)$/.test(src)) {
    //   mediaElement = createImageElement(src);
    // }
    // if (!/\.(mp4|mov|webm)$/.test(src) && !/\.(jpeg|jpg|png|gif|bmp|svg)$/.test(src)) {
    //   mediaElement = createButton(src);
    // }
    const button =createButton(src)
    div.appendChild(mediaElement)
    div.appendChild(button)
    return div;
  }
  const createButton = src => {
    const button = document.createElement("button");
    button.classList.add('btn', 'btn-outline-info','btn-sm');
    button.setAttribute('type', 'button');
    button.textContent = 'Show info';
    button.addEventListener('click', () => {
      window.open(src, '_blank');
    });
    return button;
  };

  const createImageElement = (src) => {
    const img = document.createElement('img');
    img.classList.add('mg-fluid', 'd-block');
    img.style.width = 'auto';
    img.style.maxWidth = '136px';
    img.style.height = 'auto';
    img.style.maxHeight = '106px';
    img.src = src;
    return img;
  }

  const createVideoElement= (src) =>{
    const video = document.createElement('video');
    video.style.width = 'auto';
    video.style.maxWidth = '136px';
    video.style.maxHeight = '106px';

    const source = document.createElement('source');
    source.setAttribute('src', src);
    if (src.endsWith('.mp4')) {
      source.setAttribute('type', 'video/mp4');
    } else if (src.endsWith('.mov')) {
      source.setAttribute('type', 'video/quicktime');
    } else if (src.endsWith('.webm')) {
      source.setAttribute('type', 'video/webm');
    }

    video.appendChild(source);

    video.controls = true;

    return video;
  }

  function addClickListener(element, mediaURL) {
    element.addEventListener('click', () => {
      window.open(mediaURL, '_blank');
    });
  }
  const container = createContainer();
  const url = preprocessURI(uri);
  try {
    const mediaURL = await fetchMediaURL(url);
    if (mediaURL.mediaURL) {
      appendMediaElement(container, mediaURL);
    } else {
      appendErrorElement(container, uri);
    }
  } catch {}
  return container;
}
