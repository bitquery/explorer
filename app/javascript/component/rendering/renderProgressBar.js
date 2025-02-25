export default function renderProgressBar(data = {}, variables, chainId) {
    const value = typeof data === 'string' ? parseFloat(data.replace('%', '')) : data

    const progressContainer = document.createElement('div')
    progressContainer.classList.add('progress')
    Object.assign(progressContainer.style, {
        position: 'relative',
        height: '20px',
        backgroundColor: '#e9ecef',
        borderRadius: '0.25rem'
    })

    if (isNaN(value)) {
        progressContainer.setAttribute('title', 'N/A')
        const progressText = document.createElement('span')
        progressText.textContent = 'N/A'
        Object.assign(progressText.style, {
            position: 'absolute',
            top: '50%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            color: '#000'
        })
        progressContainer.append(progressText)
        return progressContainer
    }

    progressContainer.setAttribute('title', `${value}%`)

    const progressBar = document.createElement('div')
    progressBar.classList.add('progress-bar')
    progressBar.setAttribute('role', 'progressbar')
    progressBar.setAttribute('aria-valuenow', value.toString())
    progressBar.setAttribute('aria-valuemin', '0')
    progressBar.setAttribute('aria-valuemax', '100')
    Object.assign(progressBar.style, {
        width: `${value}%`,
        backgroundColor: 'var(--bs-link-color, #007bff)',
        transition: 'width 0.6s ease',
        height: '100%',
        borderRadius: '0.25rem',
        opacity: '0.7'
    })

    const progressText = document.createElement('span')
    progressText.textContent = `${value.toFixed(1)}%`
    Object.assign(progressText.style, {
        position: 'absolute',
        top: '50%',
        left: '50%',
        transform: 'translate(-50%, -50%)',
        color: value > 50 ? '#fff' : '#000'
    })

    progressContainer.append(progressBar, progressText)
    return progressContainer
}
