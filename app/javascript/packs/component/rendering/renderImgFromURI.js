export default async function renderImgFromURI(uri) {
	const div = document.createElement('div');
	div.classList.add('text-center');
	const img = document.createElement('img');
	const video = document.createElement('video');
	video.setAttribute('type', 'video/mp4');
	video.style.maxWidth = '200px';
	video.style.maxHeight = '200px';
	img.classList.add('rounded');
	img.style.maxWidth = '50px';
	img.style.maxHeight = '50px';

	if (!uri) {
		div.style.content = '';
		return div;
	}

	let url = uri.startsWith('ipfs://') ? uri.replace(/ipfs:\/\//, 'https://ipfs.io/ipfs/') : uri;

	if (url.startsWith('https')) {
		const response = await fetch(url, { mode: 'no-cors' });
		const data = await response.json();
		let imgURL = data.image || data.image_url || data.image_data;

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
		const imgURL = json.image || json.image_url || json.image_data;

		img.src = imgURL;
		div.appendChild(img);
	}

	return div;
}
