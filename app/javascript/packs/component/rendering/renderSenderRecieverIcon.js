export default function renderSenderRecieverIcon() {
	const icon = document.createElement('i')
	icon.classList.add('fa', 'fa-sign-in', 'text-success')
	icon.style.width = '20px'
	return icon
}
