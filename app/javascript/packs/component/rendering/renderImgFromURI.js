export default async function renderImgFromURI(uri) {
	const div = document.createElement('div');
	div.classList.add('text-center');
	div.style.cursor = 'pointer';
	const img = document.createElement('img');
	const video = document.createElement('video');
	video.setAttribute('type', 'video/mp4');
	// video.style.maxWidth = '200px';
	// video.style.maxHeight = '200px';
	img.classList.add('img-fluid');

	// img.style.maxWidth = '50px';
	// img.style.maxHeight = '50px';

	const url = uri.startsWith('ipfs://') ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;
	let imgURL;
	if (url.startsWith('https:')) {
		const response = await fetch(url);
		const data = await response.json();
		imgURL = data.image || data.image_url || data.image_data;

		if (imgURL.startsWith('ipfs://')) {
			imgURL = imgURL.replace(/^ipfs:\/\//, 'https://ipfs.io/ipfs/');
		}

		if (imgURL.endsWith('.mp4')) {
			video.src = imgURL;
			video.controls = true;
			div.appendChild(video);
		} else {
			img.src = imgURL;
			div.appendChild(img);
		}
	} else if (url.startsWith('data:application/json')) {
		const base64Data = url.replace('data:application/json;base64,', '');
		const json = JSON.parse(atob(base64Data));
		imgURL = json.image || json.image_url || json.image_data;
		if (imgURL.startsWith('ipfs://')) {
			imgURL = imgURL.replace(/^ipfs:\/\//, 'https://ipfs.io/ipfs/');
		}
		img.src = imgURL;
		div.appendChild(img);
	}
	div.addEventListener('click', () => {
		window.open(imgURL, '_blank');
	});
	return div;
}
