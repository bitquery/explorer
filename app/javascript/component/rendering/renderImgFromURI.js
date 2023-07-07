import images from "../../images/no-images.jpeg"
export default async function renderImgFromURI(uri) {
  console.log('starOn',images)
  const createContainer = () => {
    const div = document.createElement('div');
    div.classList.add('position-relative');
    div.style.height = '178px';
    return div;
  };

  const preprocessURI = uri => {
    return /^ipfs:\/\//.test(uri) ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;
  };

  const fetchMediaURL = async url => {
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
    return {mediaURL, name: nameMedia};
  };

  const createButton = url => {
    const button = document.createElement('button');
    button.classList.add('btn', 'btn-outline-info', 'btn-sm', 'position-absolute');
    button.style.top = '0';
    button.style.left = '0';
    button.style.zIndex = '1';
    const icon = document.createElement('i');
    icon.classList.add('fa', 'fa-info-circle');
    button.appendChild(icon);

    if (url === null || url === 'error' || url.length <= 1) {
      button.disabled = true;
    } else {
      button.addEventListener('click', e => {
        e.stopPropagation();
        window.open(url, '_blank');
      });
    }

    return button;
  };

  const createImageElement = src => {
    const img = document.createElement('img');
    img.id = 'imgFromCard';
    img.setAttribute('onerror', `this.src=${images}`); 
    img.src = src;
    img.style.width = '100%';
    img.style.cursor = 'pointer';
    img.style.height = '100%';
    img.id = 'imgFromCard';
    img.style.objectFit = 'cover';
    return img;
  };

  const createVideoElement = src => {
    const video = document.createElement('video');
    video.classList.add('w-100', 'h-100');

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
    video.style.cursor = 'pointer';
    video.controls = true;
    return video;
  };

  const appendMediaElement = (container, mediaURL, preprocessedURI, uri) => {
    const src = mediaURL.mediaURL;
    const mediaElement = /\.(mp4|mov|webm)$/.test(src) ? createVideoElement(src) : createImageElement(src);

    const button = createButton(preprocessedURI);

    container.appendChild(mediaElement);
    container.appendChild(button);

    mediaElement.addEventListener('click', e => {
      e.stopPropagation();
      window.open(mediaURL.mediaURL, '_blank');
    });
  };

  const handleFetchError = (container, preprocessedURI) => {
    const img = createImageElement(images);
    img.style.cursor = 'default';
    const button = createButton(preprocessedURI);
    container.appendChild(img);
    if (preprocessURI !== null) {
      container.appendChild(button);
    }
  };

  const container = createContainer();
  const url = preprocessURI(uri);

  try {
    const mediaURL = await fetchMediaURL(url);
    if (mediaURL.mediaURL) {
      appendMediaElement(container, mediaURL, url, uri);
    } else {
      handleFetchError(container, url);
    }
  } catch {
    handleFetchError(container, url);
  }

  return container;
}
