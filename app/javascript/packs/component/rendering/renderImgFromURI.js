export default async function renderImgFromURI(uri) {
	function createContainer() {
		const div = document.createElement('div');
		div.style.cursor = 'pointer';
		return div;
	}
	
	function preprocessURI(uri) {
		return (/^ipfs:\/\//.test(uri) || /^ipfs:\/\//.test(uri)) ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;
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
		console.log(mediaURL)
		return { mediaURL, name: nameMedia };
	}
	
	function appendMediaElement(container, mediaURL) {
		const mediaElement = createMediaElement(mediaURL.mediaURL);
		container.appendChild(mediaElement);
		addClickListener(container, mediaURL.mediaURL);
		
		const span = document.createElement('div');
		span.textContent = mediaURL.name;
		container.appendChild(span);
	}
	
	function appendErrorElement(container, url) {
		const span = document.createElement('span');
		span.textContent = JSON.stringify(url);//'No data';
		container.appendChild(span);
	}
	
	function createMediaElement(src) {
		const mediaElement = /\.(mp4|mov|webm)$/.test(src) ? createVideoElement(src) : createImageElement(src);
		return mediaElement;
	}
	
	function createImageElement(src) {
		const img = document.createElement('img');
		img.classList.add('img-fluid', 'rounded-start');
		img.style.maxWidth = '100%';
		img.style.maxHeight = '200px';
		img.src = src;
		return img;
	}
	
	function createVideoElement(src) {
		const video = document.createElement('video');
		video.setAttribute('type', 'video/mp4');
		video.style.maxWidth = '100%';
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
	const container = createContainer();
	const url = preprocessURI(uri);
	try{

		const mediaURL = await fetchMediaURL(url);
		if (mediaURL.mediaURL) {
			appendMediaElement(container, mediaURL);
		} else {
			appendErrorElement(container, uri);
		}
		
	
	}
catch{
	console.log('ettor fetch in render img')
}
return container;
}
