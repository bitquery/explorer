export default class BootstrapCardComponent {
	constructor(element) {
		this.container = element;
		this.config = this.configuration();
		this._createWrapper();
	}

	_createWrapper() {
		this.wrapper = document.createElement('div');
		this.wrapper.classList.add('row', 'row-cols-1', 'row-cols-md-3', 'g-4');
		this.container.appendChild(this.wrapper);
	}

	onData(data, sub) {
		console.log('onData', data);
		const array = this.config.topElement(data);

		array.forEach((rowData) => {
			const cardElement = document.createElement('div');
			cardElement.classList.add('col');

			const card = document.createElement('div');
			card.classList.add('card');

			const cardImg = document.createElement('div');
			cardImg.classList.add('card-img-top');

			const cardBody = document.createElement('div');
			cardBody.classList.add('card-body"');

			const cardTitle = document.createElement('div');
			cardTitle.classList.add('card-title');

			this.config.columns.forEach((column) => {
				const span = document.createElement('h5');
				span.textContent = column.name;
				cardTitle.appendChild(span);
				const cardText = document.createElement('div');
				cardText.classList.add('card-text');
				cardBody.appendChild(cardText);

				const spanText = document.createElement('span');
				spanText.textContent = column.cell(rowData);
				cardText.appendChild(spanText);
			});

			this.config.columns.forEach(async (column) => {
				const div = await column.rendering(column.cell(rowData));
				cardImg.appendChild(div);
			});
			this.wrapper.appendChild(cardElement);
			cardElement.appendChild(card);
			card.appendChild(cardImg);
			card.appendChild(cardBody);
			cardBody.appendChild(cardTitle);
		});
	}
}
