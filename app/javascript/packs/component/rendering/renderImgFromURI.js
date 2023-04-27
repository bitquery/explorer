export default async function renderImgFromURI(uri) {
	const container = createContainer();
	const url = preprocessURI(uri);
	const mediaURL = await fetchMediaURL(url);

	if (mediaURL) {
	appendMediaElement(container, mediaURL);
	addClickListener(container, mediaURL);
	}
	return container;
}

function createContainer() {
	const div = document.createElement('div');
	// div.classList.add('text-center');
	div.style.cursor = 'pointer';
	return div;
}

function preprocessURI(uri) {
	return uri.startsWith('ipfs://') ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;
}

async function fetchMediaURL(url) {
	let mediaURL;

	if (url.startsWith('https:')) {
		const response = await fetch(url);	
		const data = await response.json();
		mediaURL = data.image || data.image_url || data.image_data;
			if (mediaURL.startsWith('ipfs://')) {
				mediaURL = mediaURL.replace(/^ipfs:\/\//, 'https://ipfs.io/ipfs/');
			}
	} else if (url.startsWith('data:application/json')) {
		const base64Data = url.replace('data:application/json;base64,', '');
		const json = JSON.parse(atob(base64Data));
		mediaURL = json.image || json.image_url || json.image_data;
			if (mediaURL.startsWith('ipfs://')) {
				mediaURL = mediaURL.replace(/^ipfs:\/\//, 'https://ipfs.io/ipfs/');
			}
	}
	return mediaURL;
}

function appendMediaElement(container, mediaURL) {
	if (mediaURL.endsWith('.mp4')) {
		const video = createVideoElement(mediaURL);
		container.appendChild(video);
	} else {
		const img = createImageElement(mediaURL);
		container.appendChild(img);
	}
}

function createImageElement(src) {
	const img = document.createElement('img');
	img.classList.add('img-fluid','rounded-start');
	img.style.maxWidth = '100%';
	img.style.maxHeight = '200px';		
	img.src = src;
	return img;
}

function createVideoElement(src) {
	const video = document.createElement('video');

	video.setAttribute('type', 'video/mp4');
   video.style.width = '100%';
   video.style.maxHeight = '200px';
	video.src = src;
	video.controls = true;	
	return video;	
}

function addClickListener(element, mediaURL) {
	element.addEventListener('click', () => {
		window.open(mediaURL, '_blank');
	});
}
