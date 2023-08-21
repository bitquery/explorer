export default async function renderImgFromURI(uri) {
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
        img.setAttribute('onerror', `this.src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAMFBMVEX////W1tbT09P5+fnr6+vZ2dnz8/P8/Pzc3Nzg4ODo6Ojy8vLv7+/j4+P39/fp6en5ZL9HAAAGS0lEQVR4nO2d6ZajIBBGWzQxxiXv/7Zz0h2FQpZCwRRzvvtrTndHuVGgim1+fgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOMAyTZ0gpiWz3twocQxTNr/2oRqJqCaT41Om3xv16DMIDnIF37T/u2DTnH2Kgl/RD7dzgot4wUY9Txnevl1+BupMVbwbj1DW0zRLM58wHPQV5/ONVk4Wo49WJ66zXUXds5UtF3OToXC6nTlXm8ug24jjpZtWw1OVuRSvzXA4fI1uM8xYsGyM2xv2OHwN2Ya6oT/e6cPwu8CQAwzz0d6nabqnJUL1GPbdYx16aYaJb1mLYTsoM4pWauY6VmI471MWbsJXhWHrzMnUjRUk1mA4+nJOVrZQgeHkE+Qpyje8+wVZ2Yx4w95SUpZw9ALiDQdT7/GaxvFJZg+ioy/SDY1WRneBrdF5qNjsknRDY5zSVDHEY3mtcEPDhLYpemwo9hCFGz68Hto9UhNlG/aBUTzdBIWvIdtQj+Lt4+x2+134NZVt+FwL5xoIXN9gFZ7ilW04hCQ2/XCS8T1DTtS89hXO+HN7hcMjvV8z7BRjLmgzdFW1UbbhUzUqPspe8TP8DbviisHGJNgMab5juK5riEVcc0hiiwYEtjQD96avwJV1fyivtzCzn1twyGwrnWPYaXu+kSz4esPeWtYQVFReDXbBLze0cvYmvFzJyH/pN9HqX0RGFa82NEq2PZ5AXGkO0pjfxGJ8PDJUc7Fha5RYlzEQ3hivtK6LvTlAHOtyrjX0jJupkfcJNUz3ZezIOE10tO1SQzK0S/7tb/DNkajmb4Eu+cErVrorDenQ7t1sU1Xn/ZTzqW/EVx9caNgRwZauhvMrBlcFMgp9nSFdoPnb9psVyj+VFBr0ZkyxXWZI5sfWSMZcd+vPpnyKKhwQ7T5d1pCsIX44f+xPNfqbs5PhLTa8yNBrMrMUf7rdDKK6MRfiXWP4MItGPczqqQItI3FU6sbeYXCFIYm1d+8WaYFChVhej09/OHQJSwQvMCSxtqPJ7FxtkIe+bdvEVfflDUms7ez2pn0/kpHihgsRdNceOlGfeZFqaUMaOfsibPpXeRULG9JY29++09As65a6soYdu+C0tuZcEF/U8JVQv6iiP2FMpqThM6EbsDuVfNsiCxrO3K78Q89MGBMpZ0hCUd4yeaKYuDui9dXdYoYk9+PudCAfStqnNCrfUy9lSGJtfll5CeOed5vm+fsyhv3h942ZTVn8fTHu7b5FDOOhqJ8Disb36eiRShhSwdR2n5swbizhuxUwJBHYgb67S+tlaNy0rxL5DbmhKLPMsUjBXgG+e7OzG9Jk71gMzU8Ye8c5DtZ3kttwN+x7CG7C6JjJ2n2vmQ3TQlE/tC773gTfCnDSfGc1bNijSlE4iv5jDszOP6+heZPjOzZ/iWdTZJBZDaTJMTr/Uob8eMRHJJtqyXKA90OzirHW3kKGaWGzGxr6WYq0Lfr77dLsf1bK8OQhFCv+hNG65aee0vmNTyGKGMYnZpn4pt9oN2+02bQy/taUEoYZhyCc2RTt5mmN73buBQwzCjoVrepmVQhrsvGex5DeMu/ZGLtsanK0MSZ0zZWaluzPMPMJaTSbGuxu3nU32lHq0YZMhvmPxng5uttP6T1xoTMEyWR4IhRlXZ8KeqMK98x/DsMigr4IO9Tptq5znSTuRlhx7ZONNNmO49UkG7peu1iLts88RBtanWDTMM4J3D142YZWOs/KXOwRAOGGh6bfaGWUbnho+i3ToMNVZ5scmX4zK6N8Q2u+h5eDGj1jDYZHpt9k7z/ckz79Vpshc72mQXWGydNv9RnSHkDUSvZskIQxms7UaJg2/ValYdJ6zToNrWwqOHJSqWHCYsZaDa2VuawNfpUZstdr1mvIzaYqNgxPv23UbMjb/TZmNbz8LGjG7jd9FvTxeXf9LV1/nnc8m9LP+fjEu96+/IUz2WOKxpnsJ+ZtzTfl8hdVK7iWfJnn6p+YFXuaN2kkQUpz4mt07rKXxrm18UP8Bt/njKBxrppYzq4u8B4TK4XzS5h887RCOL8ITbhiDsF3wibWMdsWo/2WcgkkHG7OYJwbYf8/YNIB9Tzeu63lUGZtCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD4B876PjxxyG7TAAAAAElFTkSuQmCC'`);
        img.style.objectFit = 'cover';
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
        const img = createImageElement();
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
