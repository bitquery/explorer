export default async function renderImgFromURI(uri) {
	const container = createContainer();
	const url = preprocessURI(uri);

console.log('url url url url', typeof url)
console.log('length url',  url.length)
	const mediaURL = await fetchMediaURL(url);
//  console.log(mediaURL.mediaURL)
	// 	const checkLength = mediaURL && mediaURL.mediaURL;
	// if(checkLength && checkLength.length < 5){
	// 	const span = document.createElement('span');
	// 	span.textContent = 'We don`t have picture';
	// 	container.appendChild(span);
	// }
	if (mediaURL.mediaURL) {
		const span = document.createElement('div');
		span.textContent = mediaURL.name;
		appendMediaElement(container, mediaURL.mediaURL);
		addClickListener(container, mediaURL.mediaURL);
		container.appendChild(span);

	} else {
	  const span = document.createElement('span');
	  span.textContent = 'something goes wrong';
	  container.appendChild(span);
	//   addClickListener(container, mediaURL.name);
	}
	return container;
 }
 
 function createContainer() {
	const div = document.createElement('div');
	// div.style.textAling = 'center';
	div.style.cursor = 'pointer';
	return div;
 }
 
 function preprocessURI(uri) {
	return uri.startsWith('ipfs://') ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;
 }
 //https://nfts.10ktf.com/slipstream-pass/erc-1155/440   закачался файлом
 //https://collabs.neotokyopunks.com/8222   открывает json но не производит фетч по нему??
 async function fetchMediaURL(url) {
	let mediaURL;
	let nameMedia;
	// if (url.startsWith('https:'))
	 if(/^http/.test(url)){
	  const response = await fetch(url);
	  const data = await response.json();
	  mediaURL = data.image || data.image_url || data.image_data;
	  nameMedia = data.name
	  if (mediaURL.startsWith('ipfs://')) {
		 mediaURL = mediaURL.replace(/^ipfs:\/\//, 'https://ipfs.io/ipfs/');
	  }
	} 
	if (url.startsWith('data:application/json')) {
	  const base64Data = url.replace('data:application/json;base64,', '');
	  const json = JSON.parse(atob(base64Data));
	  mediaURL = json.image || json.image_url || json.image_data;
	  nameMedia = json.name
	  if (mediaURL.startsWith('ipfs://')) {
		 mediaURL = mediaURL.replace(/^ipfs:\/\//, 'https://ipfs.io/ipfs/');
	  }
	}
	console.log({ mediaURL: mediaURL, name: nameMedia })
	return { mediaURL: mediaURL, name: nameMedia };
 }
 
 function appendMediaElement(container, mediaURL) {
	if (/\.mp4$|\.mov$|\.webm$/.test(mediaURL)) {
	  const video = createVideoElement(mediaURL);
	  container.appendChild(video);
	} else {
	  const img = createImageElement(mediaURL);
	  container.appendChild(img);
	}
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
 