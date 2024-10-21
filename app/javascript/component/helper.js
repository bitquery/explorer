const isNotEmptyArray = (subj) => Array.isArray(subj) && subj.length;
// const isNotEmptyObject = subj => !Array.isArray(subj) && typeof subj === 'object' && Object.keys(subj).length;
const isNotEmptyObject = (subj) =>
    subj != null &&
    !Array.isArray(subj) &&
    typeof subj === "object" &&
    Object.keys(subj).length;

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
    let callbacks = [];
    let widgetFrames = [];
    let variables = payload.variables;

    const getNewData = async () => {
        widgetFrames.forEach((wf) => wf.onquerystarted());
        try {
            const data = await getData(token, {...payload, variables});
            widgetFrames.forEach((wf) => wf.onqueryend());
            callbacks.forEach((cb) => cb(data, variables));
        } catch (error) {
            widgetFrames.forEach((wf) => wf.onerror(error));
        }
    };

    this.setCallback = (cb) => {
        callbacks.push(cb);
    };

    this.setWidgetFrame = (wf) => {
        widgetFrames.push(wf);
    };

    this.increaseLimit = async () => {
        variables.limit += 10;
        getNewData();
    };

    this.changeVariables = async (deltaVariables) => {
        if (deltaVariables) {
            variables = {...payload.variables, ...deltaVariables};
        }
        await getNewData();
    };

    return this;
}

export const getBaseClass = (targetClass, config) => {
    // discover functions used in class config function
    const discoverFunctions = (subj, prop) => {
        if (typeof subj === "function") {
            if (prop && subj?.name !== prop) {
                if (!data.some((el) => Object.keys(el)[0] === subj?.name)) {
                    data.unshift({[subj.name]: serialize(subj)});
                }
            }
            return;
        }
        if (isNotEmptyArray(subj)) {
            for (let el of subj) {
                discoverFunctions(el);
            }
        }
        if (isNotEmptyObject(subj)) {
            for (let prop in subj) {
                discoverFunctions(subj[prop], prop);
            }
        }
    };
    const data = [];
    data.push({[targetClass.name]: serialize(targetClass)});
    if (targetClass instanceof Function) {
        let baseClass = targetClass;

        while (baseClass) {
            const newBaseClass = Object.getPrototypeOf(baseClass);
            if (newBaseClass && newBaseClass !== Object && newBaseClass.name) {
                baseClass = newBaseClass;
                data.unshift({[baseClass.name]: serialize(baseClass)});
            } else {
                break;
            }
        }
    }
    discoverFunctions(config);
    return data;
};

export const getAPIButton = (data, variables, queryID, subscriptionDataSource) => () => {
    console.log('getAPIButton data:', data)
    console.log('getAPIButton queryID:', queryID)
    let createHiddenField = function (name, value) {
        let input = document.createElement("input");
        input.setAttribute("type", "hidden");
        input.setAttribute("name", name);
        input.setAttribute("value", value);
        return input;
    };
    let currentTabElement = document.querySelector(
        "body > div:nth-child(6) > ul > li:nth-child(1) > a"
    );
    let currentTab = currentTabElement
        ? currentTabElement.text.toLowerCase()
        : "default";
    let currentUrl = window.location.href;
    let networkPattern = /https?:\/\/[^\/]+\/(\w+)/;
    let match = currentUrl.match(networkPattern);
    let network = match ? match[1] : "default";
    let form = document.createElement("form");
    form.setAttribute("method", "post");
    form.setAttribute("action", `${window.bitqueryAPI}/widgetconfig`);
    form.setAttribute("enctype", "application/json");
    form.setAttribute("target", "_blank");
    form.appendChild(createHiddenField("data", JSON.stringify(data)));
    form.appendChild(createHiddenField("variables", JSON.stringify(variables)));
    form.appendChild(createHiddenField("url", queryID));
    form.appendChild(createHiddenField("utm_source", "explorer.bitquery.io"));
    form.appendChild(createHiddenField("utm_medium", "referral"));
    form.appendChild(
        createHiddenField("utm_campaign", encodeURIComponent(network))
    );
    form.appendChild(
        createHiddenField("utm_content", encodeURIComponent(currentTab))
    );
    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
};

export const getAPIMempoolButton =
    (data, variables, queryID, subscriptionDataSource) => () => {
        if (subscriptionDataSource && subscriptionDataSource.mempoolShow === true) {
            variables.mempool = true;
        }
        let createHiddenField = function (name, value) {
            let input = document.createElement("input");
            input.setAttribute("type", "hidden");
            input.setAttribute("name", name);
            input.setAttribute("value", value);
            return input;
        };
        let currentTabElement = document.querySelector(
            "body > div:nth-child(6) > ul > li:nth-child(1) > a"
        );
        let currentTab = currentTabElement
            ? currentTabElement.text.toLowerCase()
            : "default";
        let currentUrl = window.location.href;
        let networkPattern = /https?:\/\/[^\/]+\/(\w+)/;
        let match = currentUrl.match(networkPattern);
        let network = match ? match[1] : "default";
        let form = document.createElement("form");

        form.setAttribute("method", "post");
        form.setAttribute("action", `${window.bitqueryAPI}/widgetconfig`);
        form.setAttribute("enctype", "application/json");
        form.setAttribute("target", "_blank");
        form.appendChild(createHiddenField("data", JSON.stringify(data)));
        form.appendChild(createHiddenField("variables", JSON.stringify(variables)));
        form.appendChild(createHiddenField("url", queryID));
        form.appendChild(createHiddenField("utm_source", "explorer.bitquery.io"));
        form.appendChild(createHiddenField("utm_medium", "referral"));
        form.appendChild(
            createHiddenField("utm_campaign", encodeURIComponent(network))
        );
        form.appendChild(
            createHiddenField("utm_content", encodeURIComponent(currentTab))
        );
        document.body.appendChild(form);
        form.submit();
        document.body.removeChild(form);
    };

export const increaseLimitButton = (historyDataSource) => () => {
    // clearData()
    historyDataSource.increaseLimit();
};

export const switchDataset =
    (widgetFrame, historyDataSource, subscriptionDataSource) => (e) => {
        subscriptionDataSource.unsubscribe();
        e.currentTarget.textContent = "History query";
        widgetFrame.onquerystarted();
        historyDataSource.changeVariables();
        e.currentTarget.classList.add("button-pressed");
        e.currentTarget.nextSibling.textContent = "⏸ Mempool";
        e.currentTarget.nextSibling.nextSibling.textContent = "⏸ Streaming";
        e.currentTarget.parentElement.lastChild.classList.add("hide");
        e.currentTarget.nextSibling.textContent = "▶ Mempool";
        e.currentTarget.nextSibling.nextSibling.textContent = "▶ Streaming";
        e.currentTarget.nextSibling.classList.remove("button-pressed");
        e.currentTarget.nextSibling.nextSibling.classList.remove("button-pressed");
    };

export const mempoolStreamControl =
    (subscriptionDataSource, widgetFrame) => (e) => {
        if (subscriptionDataSource.alive) {
            subscriptionDataSource.unsubscribe();
            widgetFrame.onqueryend();
            e.currentTarget.parentElement.lastChild.classList.add("hide");
            e.currentTarget.classList.remove("button-pressed");
            e.currentTarget.textContent = "▶ Mempool";
            e.currentTarget.nextSibling.textContent = "▶ Streaming";
            e.currentTarget.nextSibling.classList.remove("button-pressed");
            e.currentTarget.previousSibling.classList.remove("button-pressed");
        } else {
            subscriptionDataSource.unsubscribe();
            widgetFrame.onquerystarted();
            subscriptionDataSource.changeVariables({mempool: true});
            e.currentTarget.parentElement.lastChild.classList.remove("hide");
            e.currentTarget.classList.add("button-pressed");
            e.currentTarget.textContent = "⏸ Mempool";
            e.currentTarget.nextSibling.textContent = "▶ Streaming";
            e.currentTarget.nextSibling.classList.remove("button-pressed");
            e.currentTarget.previousSibling.classList.remove("button-pressed");
        }
    };

export const streamControl = (subscriptionDataSource, widgetFrame) => (e) => {
    if (subscriptionDataSource.alive) {
        subscriptionDataSource.unsubscribe();
        widgetFrame.onqueryend();
        e.currentTarget.parentElement.lastChild.classList.add("hide");
        e.currentTarget.classList.remove("button-pressed");
        e.currentTarget.textContent = "▶ Streaming";
        e.currentTarget.previousSibling.textContent = "▶ Mempool";
        e.currentTarget.previousSibling.classList.remove("button-pressed");
        e.currentTarget.previousSibling.previousSibling.classList.remove(
            "button-pressed"
        );
    } else {
        subscriptionDataSource.unsubscribe();
        widgetFrame.onquerystarted();
        subscriptionDataSource.changeVariables({mempool: false});
        e.currentTarget.parentElement.lastChild.classList.remove("hide");
        e.currentTarget.classList.add("button-pressed");
        e.currentTarget.textContent = "⏸ Streaming";
        e.currentTarget.previousSibling.textContent = "▶ Mempool";
        e.currentTarget.previousSibling.classList.remove("button-pressed");
        e.currentTarget.previousSibling.previousSibling.classList.remove(
            "button-pressed"
        );
    }
};

export const getQueryParams = async (queryID) => {
    const response = await fetch(`${window.bitqueryAPI}/getquery/${queryID}`);
    const {endpoint_url, variables, query, name} = await response.json();
    return {
        variables: JSON.parse(variables),
        query,
        endpoint_url,
        name,
    };
};

export const getData = async (token, {endpoint_url, query, variables}) => {
    const response = await fetch(endpoint_url, {
        method: "POST",
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
            Authorization: token,
        },
        body: JSON.stringify({query, variables}),
        credentials: "same-origin",
    });
    if (response.status !== 200) {
        throw new Error(response.error);
    }
    const {data, errors} = await response.json();
    if (errors) {
        throw new Error(errors[0].message);
    }
    return data;
};

export const createWidgetFrame = (
    selector,
    subscriptionQueryID,
    historyQueryID,
    subscriptionDataSource
) => {
    const createBadge = (title, display, additionalClasses = "") => {
        const button = document.createElement("a");
        if (!display) {
            button.style.display = "none";
            return button;
        }
        button.classList.add(
            "badge",
            "badge-success",
            "p-1",
            "button-transition",
            ...additionalClasses.split(" ")
        );
        button.style.background = "#08BDB1";
        button.setAttribute("role", "button");
        button.setAttribute("target", "_blank");
        button.textContent = title;
        return button;
    };

    const setupShowMoreButton = (tableFooter, showMoreButton) => () => {
        tableFooter.style.justifyContent = "space-between";
        tableFooter.insertBefore(showMoreButton, tableFooter.firstChild);
    };

    const componentContainer = document.querySelector(selector);
    const widgetHeader = document.createElement("div");
    const row = document.createElement("div");
    const col8 = document.createElement("div");
    const cardBody = document.createElement("div");
    const widgetFrame = document.createElement("div");
    const tableFooter = document.createElement("div");

    const getStreamingAPIButton = createBadge(
        "Get Streaming API",
        subscriptionQueryID,
        "mx-2"
    );
    const getMempoolButton = createBadge(
        "Get Mempool API",
        subscriptionQueryID,
        "mx-2"
    );
    const getHistoryAPIButton = createBadge(
        "Get History API",
        historyQueryID,
        "mx-2"
    );
    const switchButton = createBadge("History query", true, "mx-2");
    const showMoreButton = document.createElement("a");
    const streamControlButton = createBadge("▶ Streaming", true, "mx-2");
    const mempoolControlButton = createBadge("▶ Mempool", true, "mx-2");

    if (!subscriptionQueryID) {
        switchButton.style.display = "none";
        streamControlButton.style.display = "none";
    }

    if (subscriptionDataSource?.mempoolShow !== true) {
        mempoolControlButton.style.display = "none";
        getMempoolButton.style.display = "none";
    }

    switchButton.id = "switchButton";
    streamControlButton.id = "streamControlButton";
    getMempoolButton.id = "getMempoolButton";
    mempoolControlButton.id = "mempoolControlButton";
    switchButton.classList.add("button-pressed");
    showMoreButton.classList.add("more-link", "badge");
    showMoreButton.textContent = "Show more...";
    showMoreButton.style.cursor = "pointer";

    const loader = document.createElement("div");
    const blinkerWrapper = document.createElement("div");
    blinkerWrapper.classList.add("hide");
    loader.classList.add("lds-dual-ring");
    tableFooter.style.display = "flex";
    tableFooter.style.justifyContent = "end";
    tableFooter.appendChild(getHistoryAPIButton);
    tableFooter.appendChild(getStreamingAPIButton);
    tableFooter.appendChild(getMempoolButton);

    widgetHeader.classList.add("card-header");
    row.classList.add("row", "align-items-center", "pr-3", "pl-3");
    col8.classList.add("col-auto");
    col8.classList.add(selector);
    col8.style.flex = "1";
    cardBody.classList.add("card-body", "text-center");
    widgetFrame.classList.add("widget-container", "tabulator");
    widgetFrame.style.height = "fit-content";
    widgetFrame.style.background = "inherit";

    mempoolControlButton.style.setProperty("background", "#FDA146", "important");
    getMempoolButton.style.setProperty("background", "#FDA146", "important");

    componentContainer.appendChild(widgetHeader);
    componentContainer.appendChild(cardBody);
    cardBody.appendChild(widgetFrame);
    cardBody.appendChild(tableFooter);
    widgetHeader.appendChild(row);
    row.appendChild(col8);
    const buttonContainer = document.createElement("div");
    buttonContainer.classList.add("col-auto", "d-flex", "align-items-center");
    buttonContainer.appendChild(switchButton);
    buttonContainer.appendChild(mempoolControlButton);
    buttonContainer.appendChild(streamControlButton);
    row.appendChild(buttonContainer);

    const f = setupShowMoreButton(tableFooter, showMoreButton);

    const onloadmetadata = (queryMetaData) => {
        col8.textContent = queryMetaData?.name || "No query presented";
        if (queryMetaData.query.match(/subscription[^a-zA-z0-9]/gm)) {
            const blinker = document.createElement("div");
            blinkerWrapper.classList.add("text-success", "text-right", "hide");
            blinker.classList.add("blink", "blnkr", "bg-success");
            blinker.style.marginLeft = "-5px";
            row.appendChild(blinkerWrapper);
            blinkerWrapper.appendChild(blinker);
        }
    };

    const onquerystarted = () => {
        cardBody.appendChild(loader);
    };

    const onqueryend = () => {
        loader.parentElement === cardBody && cardBody.removeChild(loader);
    };

    const onerror = (error) => {
        if (row.contains(blinkerWrapper)) {
            row.removeChild(blinkerWrapper);
        }
        cardBody.textContent = "";
        cardBody.classList.add("alert", "alert-danger");
        cardBody.setAttribute("role", "alert");
        const title = document.createElement("h4");
        title.classList.add("alert-heading");
        const errorText = document.createElement("div");
        errorText.classList.add("mb-0");
        cardBody.appendChild(title);
        cardBody.appendChild(errorText);
        title.textContent =
            "An error occurred while executing the request. Please, try again later";
        if (Array.isArray(error)) {
            errorText.textContent = `Error: ${error[0].message}`;
        } else if ("message" in error) {
            errorText.textContent = `Error: ${error.message}`;
        } else {
            errorText.textContent = `Error: ${error}`;
        }
    };

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
    };
};
