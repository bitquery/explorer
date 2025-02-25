const isNotEmptyArray = (subj) => Array.isArray(subj) && subj.length
const isNotEmptyObject = (subj) =>
    subj != null &&
    !Array.isArray(subj) &&
    typeof subj === "object" &&
    Object.keys(subj).length

export function SubscriptionDataSource(token, payload) {
    let variables, cleanSubscription;
    let callbacks = [];
    let widgetFrames = [];
    this.mempoolShow =
        !payload.variables.mempool && payload.variables.network !== "arbitrum";

    this.subscribe = () => {
        const currentUrl = payload.endpoint_url.replace(/^http/, "ws");
        const tokenForStreaming = token.replace(/^Bearer\s*/, "").trim();
        const client = createClient({
            url: `${currentUrl}?token=${tokenForStreaming}`,
            connectionParams: async () => {
                return {
                    headers: {
                        Authorization: token,
                    },
                };
            },
        });
        this.alive = true;
        try {
            cleanSubscription = client.subscribe(
                {query: payload.query, variables},
                {
                    next: ({data}) => {
                        callbacks.forEach((cb, i) => {
                            widgetFrames[i].onqueryend();
                            cb(data, variables);
                        });
                    },
                    error: (error) => {
                        widgetFrames.forEach((wf) => wf.onerror("connection error"));
                        this.unsubscribe();
                    },
                    complete: () => {
                        this.alive = false;
                    },
                }
            );
        } catch (error) {
            widgetFrames.forEach((wf) => wf.onerror(error));
            this.unsubscribe();
        }
    };

    this.setCallback = (cb) => {
        callbacks.push(cb);
    };

    this.setWidgetFrame = (wf) => {
        widgetFrames.push(wf);
    };

    this.changeVariables = async (deltaVariables) => {
        variables = {...payload.variables, ...deltaVariables};
        cleanSubscription && cleanSubscription();
        this.subscribe();
    };

    this.unsubscribe = () => {
        cleanSubscription && cleanSubscription();
        this.alive = false;
        cleanSubscription = null;
    };

    return this;
}
export function HistoryDataSource(token, payload) {
    let callbacks = []
    let widgetFrames = []
    let variables = payload.variables

    const getNewData = async () => {
        widgetFrames.forEach((wf) => wf.onquerystarted())
        try {
            const data = await getData(token, { ...payload, variables })
            widgetFrames.forEach((wf) => wf.onqueryend())
            callbacks.forEach((cb) => cb(data, variables))
        } catch (error) {
            widgetFrames.forEach((wf) => wf.onerror(error))
        }
    }

    this.setCallback = (cb) => {
        callbacks.push(cb)
    }

    this.setWidgetFrame = (wf) => {
        widgetFrames.push(wf)
    }

    this.increaseLimit = async () => {
        variables.limit += 10
        getNewData()
    }

    this.changeVariables = async (deltaVariables) => {
        if (deltaVariables) {
            variables = { ...payload.variables, ...deltaVariables }
        }
        await getNewData()
    }

    return this
}

export const getBaseClass = (targetClass, config) => {
    const discoverFunctions = (subj, prop) => {
        if (typeof subj === "function") {
            if (prop && subj?.name !== prop) {
                if (!data.some((el) => Object.keys(el)[0] === subj?.name)) {
                    data.unshift({ [subj.name]: serialize(subj) })
                }
            }
            return
        }
        if (isNotEmptyArray(subj)) {
            for (let el of subj) {
                discoverFunctions(el)
            }
        }
        if (isNotEmptyObject(subj)) {
            for (let prop in subj) {
                discoverFunctions(subj[prop], prop)
            }
        }
    }
    const data = []
    data.push({ [targetClass.name]: serialize(targetClass) })
    if (targetClass instanceof Function) {
        let baseClass = targetClass
        while (baseClass) {
            const newBaseClass = Object.getPrototypeOf(baseClass)
            if (newBaseClass && newBaseClass !== Object && newBaseClass.name) {
                baseClass = newBaseClass
                data.unshift({ [baseClass.name]: serialize(baseClass) })
            } else {
                break
            }
        }
    }
    discoverFunctions(config)
    return data
}

export const getAPIButton = (data, variables, queryID, subscriptionDataSource) => () => {
    let createHiddenField = function (name, value) {
        let input = document.createElement("input")
        input.setAttribute("type", "hidden")
        input.setAttribute("name", name)
        input.setAttribute("value", value)
        return input
    }
    let currentTabElement = document.querySelector(
        "body > div:nth-child(6) > ul > li:nth-child(1) > a"
    )
    let currentTab = currentTabElement
        ? currentTabElement.text.toLowerCase()
        : "default"
    let currentUrl = window.location.href
    let networkPattern = /https?:\/\/[^\/]+\/(\w+)/
    let match = currentUrl.match(networkPattern)
    let network = match ? match[1] : "default"
    let form = document.createElement("form")
    form.setAttribute("method", "post")
    form.setAttribute("action", `${window.bitqueryAPI}/widgetconfig`)
    form.setAttribute("enctype", "application/json")
    form.setAttribute("target", "_blank")
    form.appendChild(createHiddenField("data", JSON.stringify(data)))
    form.appendChild(createHiddenField("variables", JSON.stringify(variables)))
    form.appendChild(createHiddenField("url", queryID))
    form.appendChild(createHiddenField("utm_source", "explorer.bitquery.io"))
    form.appendChild(createHiddenField("utm_medium", "referral"))
    form.appendChild(createHiddenField("utm_campaign", encodeURIComponent(network)))
    form.appendChild(createHiddenField("utm_content", encodeURIComponent(currentTab)))
    document.body.appendChild(form)
    form.submit()
    document.body.removeChild(form)
}

export const getAPIMempoolButton =
    (data, variables, queryID, subscriptionDataSource) => () => {
        if (subscriptionDataSource && subscriptionDataSource.mempoolShow === true) {
            variables.mempool = true
        }
        let createHiddenField = function (name, value) {
            let input = document.createElement("input")
            input.setAttribute("type", "hidden")
            input.setAttribute("name", name)
            input.setAttribute("value", value)
            return input
        }
        let currentTabElement = document.querySelector(
            "body > div:nth-child(6) > ul > li:nth-child(1) > a"
        )
        let currentTab = currentTabElement
            ? currentTabElement.text.toLowerCase()
            : "default"
        let currentUrl = window.location.href
        let networkPattern = /https?:\/\/[^\/]+\/(\w+)/
        let match = currentUrl.match(networkPattern)
        let network = match ? match[1] : "default"
        let form = document.createElement("form")
        form.setAttribute("method", "post")
        form.setAttribute("action", `${window.bitqueryAPI}/widgetconfig`)
        form.setAttribute("enctype", "application/json")
        form.setAttribute("target", "_blank")
        form.appendChild(createHiddenField("data", JSON.stringify(data)))
        form.appendChild(createHiddenField("variables", JSON.stringify(variables)))
        form.appendChild(createHiddenField("url", queryID))
        form.appendChild(createHiddenField("utm_source", "explorer.bitquery.io"))
        form.appendChild(createHiddenField("utm_medium", "referral"))
        form.appendChild(createHiddenField("utm_campaign", encodeURIComponent(network)))
        form.appendChild(createHiddenField("utm_content", encodeURIComponent(currentTab)))
        document.body.appendChild(form)
        form.submit()
        document.body.removeChild(form)
    }

export const increaseLimitButton = (historyDataSource) => () => {
    historyDataSource.increaseLimit()
}

export const mempoolStreamControl = (subscriptionDataSource, widgetFrame) => (e) => {
    const currentButton = e.currentTarget;

    currentButton.classList.add("button-pressed");
    currentButton.textContent = "⏸ Mempool";

    const nextButton = currentButton.nextSibling;
    const prevButton = currentButton.previousSibling;

    if (nextButton) {
        nextButton.classList.remove("button-pressed");
        nextButton.textContent = "▶ Streaming";
    }

    if (prevButton) {
        prevButton.classList.remove("button-pressed");
        prevButton.textContent = "▶ History query";
    }

    widgetFrame.onquerystarted();
    subscriptionDataSource.changeVariables({ mempool: true });

    if (widgetFrame.blinkerWrapper) {
        widgetFrame.blinkerWrapper.classList.remove("hide");
    }
};

export const streamControl = (subscriptionDataSource, widgetFrame) => (e) => {
    const currentButton = e.currentTarget;

    currentButton.classList.add("button-pressed");
    currentButton.textContent = "⏸ Streaming";

    const prevButton = currentButton.previousSibling;

    if (prevButton) {
        prevButton.classList.remove("button-pressed");
        prevButton.textContent = "▶ Mempool";
    }

    const prevPrevButton = prevButton?.previousSibling;
    if (prevPrevButton) {
        prevPrevButton.classList.remove("button-pressed");
        prevPrevButton.textContent = "▶ History query";
    }

    widgetFrame.onquerystarted();
    subscriptionDataSource.changeVariables({ mempool: false });

    if (widgetFrame.blinkerWrapper) {
        widgetFrame.blinkerWrapper.classList.remove("hide");
    }
};

export const switchDataset = (widgetFrame, historyDataSource, subscriptionDataSource) => (e) => {
    const currentButton = e.currentTarget;

    currentButton.classList.add("button-pressed");
    currentButton.textContent = "History query";

    const nextButton = currentButton.nextSibling;
    const nextNextButton = nextButton?.nextSibling;

    if (nextButton) {
        nextButton.classList.remove("button-pressed");
        nextButton.textContent = "▶ Mempool";
    }

    if (nextNextButton) {
        nextNextButton.classList.remove("button-pressed");
        nextNextButton.textContent = "▶ Streaming";
    }

    subscriptionDataSource.unsubscribe();
    widgetFrame.onquerystarted();
    historyDataSource.changeVariables();

    if (widgetFrame.blinkerWrapper) {
        widgetFrame.blinkerWrapper.classList.add("hide");
    }
};
export const getQueryParams = async (queryID) => {
    const response = await fetch(`${window.bitqueryAPI}/getquery/${queryID}`)
    const { endpoint_url, variables, query, name } = await response.json()
    return {
        variables: JSON.parse(variables),
        query,
        endpoint_url,
        name,
    }
}

export const getData = async (token, { endpoint_url, query, variables }) => {
    const response = await fetch(endpoint_url, {
        method: "POST",
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
            Authorization: token,
        },
        body: JSON.stringify({ query, variables }),
        credentials: "same-origin",
    })
    if (response.status !== 200) {
        throw new Error(response.error)
    }
    const { data, errors } = await response.json()
    if (errors) {
        throw new Error(errors[0].message)
    }
    return data
}

export const createWidgetFrame = (
    selector,
    subscriptionQueryID,
    historyQueryID,
    subscriptionDataSource
) => {
    const createBadge = (title, display, additionalClasses = "") => {
        const button = document.createElement("a")
        if (!display) {
            button.style.display = "none"
            return button
        }
        button.classList.add(
            "badge",
            "text-white",
            "bg-custom-purple",
            "rounded-sm",
            "px-3",
            "py-1",
            "button-transition",
            ...additionalClasses.split(" ")
        )
        button.setAttribute("role", "button")
        button.setAttribute("target", "_blank")
        button.textContent = title
        return button
    }
    const setupShowMoreButton = (tableFooter, showMoreButton) => () => {
        tableFooter.style.justifyContent = "space-end"
        tableFooter.insertBefore(showMoreButton, tableFooter.firstChild)
    }

    const componentContainer = document.querySelector(selector)
    const widgetHeader = document.createElement("div")
    const row = document.createElement("div")
    const col8 = document.createElement("div")
    const cardBody = document.createElement("div")
    const widgetFrame = document.createElement("div")
    const tableFooter = document.createElement("div")

    const getStreamingAPIButton = createBadge(
        "Get Streaming API",
        subscriptionQueryID,
        "mx-2"
    )
    const getMempoolButton = createBadge(
        "Get Mempool API",
        subscriptionQueryID,
        "mx-2"
    )
    const getHistoryAPIButton = createBadge(
        "Get History API",
        historyQueryID,
        "mx-2"
    )
    const switchButton = createBadge("History query", true, "mx-2")
    const showMoreButton = document.createElement("a")
    const streamControlButton = createBadge("▶ Streaming", true, "mx-2")
    const mempoolControlButton = createBadge("▶ Mempool", true, "mx-2")

    if (!subscriptionQueryID) {
        switchButton.style.display = "none"
        streamControlButton.style.display = "none"
    }
    if (subscriptionDataSource?.mempoolShow !== true) {
        mempoolControlButton.style.display = "none"
        getMempoolButton.style.display = "none"
    }

    switchButton.id = "switchButton"
    streamControlButton.id = "streamControlButton"
    getMempoolButton.id = "getMempoolButton"
    mempoolControlButton.id = "mempoolControlButton"
    switchButton.classList.add("button-pressed")
    showMoreButton.classList.add("more-link", "badge")
    showMoreButton.textContent = "  "
    showMoreButton.style.cursor = "pointer"

    const loader = document.createElement("div")

    const buttonContainer = document.createElement("div")
    buttonContainer.classList.add("col-auto", "d-flex", "align-items-center")

    const blinkerWrapper = document.createElement("div")
    blinkerWrapper.classList.add("hide")
    const blink = document.createElement("div")
    blink.classList.add("blink")
    blinkerWrapper.appendChild(blink)
    buttonContainer.appendChild(blinkerWrapper)
    buttonContainer.appendChild(switchButton)
    buttonContainer.appendChild(mempoolControlButton)
    buttonContainer.appendChild(streamControlButton)
    row.appendChild(buttonContainer)
    widgetFrame.blinkerWrapper = blinkerWrapper

    tableFooter.style.display = "flex"
    tableFooter.style.justifyContent = "end"
    tableFooter.appendChild(getHistoryAPIButton)
    tableFooter.appendChild(getStreamingAPIButton)
    tableFooter.appendChild(getMempoolButton)

    widgetHeader.classList.add("card-header")
    row.classList.add("row", "align-items-center", "pr-3", "pl-3")
    col8.classList.add("col-auto")
    col8.classList.add(selector)
    col8.style.flex = "1"
    cardBody.classList.add("card-body", "text-center")
    widgetFrame.classList.add("widget-container", "tabulator")
    widgetFrame.style.height = "fit-content"
    widgetFrame.style.background = "inherit"

    mempoolControlButton.style.setProperty("background", "#ff7b4c", "important")
    getMempoolButton.style.setProperty("background", "#ff7b4c", "important")

    componentContainer.appendChild(widgetHeader)
    componentContainer.appendChild(cardBody)
    cardBody.appendChild(widgetFrame)
    cardBody.appendChild(tableFooter)
    widgetHeader.appendChild(row)
    row.appendChild(col8)

    row.appendChild(buttonContainer)

    const f = setupShowMoreButton(tableFooter, showMoreButton)

    const onloadmetadata = (queryMetaData) => {
        col8.textContent = queryMetaData?.name || "No query presented"
    }
    const onquerystarted = () => {
        const existingOverlays = cardBody.querySelectorAll(".loading-overlay");
        existingOverlays.forEach((overlay) => overlay.remove());

        const overlay = document.createElement("div");
        overlay.className = "loading-overlay";
        overlay.innerHTML = `
        <div class="progress-container">
            <p class="progress-text">Loading...</p>
            <div class="progress-bar"></div>
        </div>
    `;
        cardBody.style.position = "relative";
        cardBody.appendChild(overlay);

        requestAnimationFrame(() => {
            overlay.classList.add("show");
        });

        const progressBar = overlay.querySelector(".progress-bar");
        let progress = 0;
        const startTime = Date.now();
        const duration = 3000;

        const updateProgress = () => {
            const elapsedTime = Date.now() - startTime;
            const remainingTime = Math.max(0, duration - elapsedTime);
            const progressSpeed = remainingTime > 0 ? (90 - progress) / (remainingTime / 50) : 100;

            if (progress < 90) {
                progress += progressSpeed;
                progress = Math.min(progress, 90);
                progressBar.style.width = progress + "%";
                requestAnimationFrame(updateProgress);
            } else {
                progressBar.classList.add("progress-bounce");
            }
        };

        updateProgress();
        overlay.dataset.startTime = startTime;
    };

    const onqueryend = () => {
        const overlays = cardBody.querySelectorAll(".loading-overlay");
        overlays.forEach((overlay) => {
            const progressBar = overlay.querySelector(".progress-bar");
            progressBar.style.width = "100%";

            overlay.classList.remove("show");
            setTimeout(() => {
                overlay.remove();
            }, 300);
        });
    };

    const onerror = (error) => {
        const overlay = cardBody.querySelector(".loading-overlay")
        if (overlay) {
            overlay.remove()
        }

        const errorContainer = document.createElement("div")
        errorContainer.classList.add("alert", "alert-danger")
        errorContainer.setAttribute("role", "alert")

        const title = document.createElement("h4")
        title.classList.add("alert-heading")
        title.textContent = "An error occurred while executing the request. Please, try again later"

        const errorText = document.createElement("div")
        errorText.classList.add("mb-0")
        if (Array.isArray(error)) {
            errorText.textContent = `Error: ${error[0].message}`
        } else if ("message" in error) {
            errorText.textContent = `Error: ${error.message}`
        } else {
            errorText.textContent = `Error: ${error}`
        }

        errorContainer.appendChild(title)
        errorContainer.appendChild(errorText)

        cardBody.insertBefore(errorContainer, cardBody.firstChild)
    }

    return {
        frame: widgetFrame,
        getHistoryAPIButton,
        getStreamingAPIButton,
        getMempoolButton,
        switchButton,
        streamControlButton,
        mempoolControlButton,
        showMoreButton,
        setupShowMoreButton: f,
        onloadmetadata,
        onquerystarted,
        onqueryend,
        onerror,
        blinkerWrapper
    }
}
