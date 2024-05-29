// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import '../stylesheets/application';

require.context('cryptocurrency-icons/svg', true);
require('@rails/ujs').start();
require('@rails/activestorage').start();
require('channels');
require('jquery');
require('popper.js');
require('bootstrap');
require('daterangepicker');

import barWidgetRenderer from 'vega-widgets/src/components/widgets/barWidgetRenderer';
import pieWidgetRenderer from 'vega-widgets/src/components/widgets/pieWidgetRenderer';
import timeChartRenderer from '@bitquery/ide-charts/src/reactComponents/timeChartRenderer';
// import tableWidgetRenderer from "table-widget/src/components/tableWidgetRenderer";
import tableWidgetRenderer from './tableWidgetRenderer';
import tradingViewrenderer from '@bitquery/ide-tradingview/src/tradingViewRenderer';
import {createChart} from 'lightweight-charts';
import {micromark} from 'micromark';
import ClipboardJS from 'clipboard';
import moment from 'moment';
import vis from 'vis';
import numeral from 'numeral';
import * as SockJS from 'sockjs-client';
import Stomp from 'stompjs';
import {Wallet} from './walletC';
import {createClient, Client} from 'graphql-ws/lib/client';
import serialize from 'serialize-javascript';
import WidgetConfig from '../component/componentDescription/WidgetConfig';
import BootstrapTableComponent from '../component/componentDescription/BootstrapTableComponent';
import BootstrapCardComponent from '../component/componentDescription/BootstrapCardComponent';
import GraphsComponent from '../component/componentDescription/GraphsComponent';
import TradingGraphsComponent from '../component/componentDescription/TradingGraphsComponent';
import BootstrapVerticalTableComponent from '../component/componentDescription/BootstrapVerticalTableComponent';
import TimeChartComponent from '../component/componentDescription/TimeChartComponent';
import BarChartComponent from '../component/componentDescription/BarChartComponent';
import PieChartComponent from '../component/componentDescription/PieChartComponent';
import TreeComponent from '../component/componentDescription/TreeComponent';
import LineChartComponent from '../component/componentDescription/LineChartComponent';
import renderComponent from '../component/component';
import renderImgFromURI from '../component/rendering/renderImgFromURI';
import renderTokenLink from '../component/rendering/renderTokenLink';
import renderDate from '../component/rendering/renderDate';
import renderTX from '../component/rendering/renderTX';
import renderIdLink from '../component/rendering/renderIdLink';
import renderDexProtocolLink from '../component/rendering/renderDexProtocolLink';
import renderJustAddressLink from '../component/rendering/renderJustAddressLink';
import renderBlockLink from '../component/rendering/renderBlockLink';
import renderSenderRecieverIcon from '../component/rendering/renderSenderRecieverIcon';
import renderPairLink from '../component/rendering/renderPairLink';
import renderNumbers from '../component/rendering/renderNumbers';
import renderNumbersWithCurrency from '../component/rendering/renderNumbersWithCurrency';
import renderNumbersWithCurrencySymbol from '../component/rendering/renderNumbersWithCurrencySymbol';
import renderMethodLink from '../component/rendering/renderMethodLink';
import renderEventLink from '../component/rendering/renderEventLink';
import renderBytes32 from "../component/rendering/renderBytes32";
import renderNumberWithUSD from "../component/rendering/renderNumberWithUSD";
import ComboChartComponent from "../component/componentDescription/ComboChartComponent";

const Datafeeds = require("packs/datafeeds/bundle")
const TradingView = require("packs/charting_library/charting_library")
const TreeView = require('js-treeview');

global.Datafeeds = Datafeeds;
global.TradingView = TradingView;
global.TreeView = TreeView;
global.serialize = serialize;
global.createClient = createClient;
global.createChart = createChart;
global.WidgetConfig = WidgetConfig;
global.BootstrapTableComponent = BootstrapTableComponent;
global.GraphsComponent = GraphsComponent;
global.TradingGraphsComponent = TradingGraphsComponent;
global.TimeChartComponent = TimeChartComponent;
global.PieChartComponent = PieChartComponent;
global.BarChartComponent = BarChartComponent;
global.BootstrapCardComponent = BootstrapCardComponent;
global.BootstrapVerticalTableComponent = BootstrapVerticalTableComponent;
global.TreeComponent = TreeComponent;
global.LineChartComponent = LineChartComponent;
global.renderComponent = renderComponent;
global.ComboChartComponent = ComboChartComponent;
global.renderImgFromURI = renderImgFromURI;
global.renderTokenLink = renderTokenLink;
global.renderIdLink = renderIdLink;
global.renderBlockLink = renderBlockLink;
global.renderDate = renderDate;
global.renderTX = renderTX;
global.renderDexProtocolLink = renderDexProtocolLink;
global.renderJustAddressLink = renderJustAddressLink;
global.renderSenderRecieverIcon = renderSenderRecieverIcon;
global.renderPairLink = renderPairLink;
global.renderNumbers = renderNumbers;
global.renderNumbersWithCurrency = renderNumbersWithCurrency;
global.renderNumbersWithCurrencySymbol = renderNumbersWithCurrencySymbol;
global.renderMethodLink = renderMethodLink;
global.renderEventLink = renderEventLink;
global.renderBytes32 = renderBytes32;
global.renderNumberWithUSD = renderNumberWithUSD;

global.widgetRenderer = {
    'vega.bar': barWidgetRenderer,
    'vega.pie': pieWidgetRenderer,
    'time.chart': timeChartRenderer,
    'table.widget': tableWidgetRenderer,
    'tradingview.widget': tradingViewrenderer,
};
global.Stomp = Stomp;
global.SockJS = SockJS;
global.$ = $;
global.vis = vis;
global.numeral = numeral;
global.m = moment;
const chainName = {
    '0x1': 'Ethereum',
    '0xa': 'Optimism',
    '0x3b': 'EOS',
    '0x3d': 'Ethclassic',
    '0x19': 'Cronos',
    '0x38': 'BSC',
    '0x89': 'Matic',
    '0xfa': 'Fantom',
    '0x504': 'Moonbeam',
    '0x2019': 'Klaytn',
    '0xa4ec': 'Celo',
    solana: 'Solana',
};

const WALLET = {
    METAMASK: 'metamask',
    PHANTOM: 'phantom',
    EXODUS: 'exodus',
    COINBASE: 'coinbase',
};

function setupWalletConnection() {
    if (!window?.phantom?.solana?.isPhantom) {
        const button = document.querySelector('button[data-value="#phantom"]');
        button.setAttribute('disabled', '');
    }
    if (!window?.ethereum?.providers?.length) {
        if (!window?.ethereum?.isMetaMask) {
            const button = document.querySelector('button[data-value="#metamask"]');
            button.setAttribute('disabled', '');
        }
        if (!window?.ethereum?.isCoinbaseWallet) {
            const button = document.querySelector('button[data-value="#coinbase"]');
            button.setAttribute('disabled', '');
        }
    }

    const setupHref = (chainId, address) => {
        location.href = `${location.protocol}//${location.host}/${chainName[
            chainId
            ].toLowerCase()}/address/${address}?from=${
            new Date(new Date().setDate(new Date().getDate() - 1825)).toISOString().split('T')[0]
        }&till=${new Date().toISOString().split('T')[0]}`;
    };

    const setupConnectionButton = () => {
        if (connectionList.length) {
            // option setup
            const woWallet = currentConnection.split('+')[0];
            const woNetwork = currentConnection.split('+')[1];
            const woAddress = currentConnection.split('+')[2];
            walletOptions.textContent = '';
            const woIcon = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            woIcon.classList.add('wallet-icon');
            const woUseElem = document.createElementNS('http://www.w3.org/2000/svg', 'use');
            woUseElem.setAttributeNS('http://www.w3.org/1999/xlink', 'xlink:href', `#${woWallet}`);
            woIcon.appendChild(woUseElem);
            const network = document.createElement('div');
            network.classList.add('network');
            network.textContent = chainName[woNetwork];
            const address = document.createElement('div');
            address.classList.add('address', 'ml-2');
            address.textContent = woAddress;
            walletOptions.appendChild(woIcon);
            walletOptions.appendChild(network);
            walletOptions.appendChild(address);
            //end
            walletDrowdownMenu.textContent = '';
            const walletConnectionButton = document.querySelector('#wallet-connection');
            walletConnectionButton.classList.add('d-none');
            const dropdown = document.querySelector('.dropdown');
            dropdown.classList.remove('d-none');
            for (const connection of connectionList) {
                const icon = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
                icon.classList.add('wallet-icon');
                const useElem = document.createElementNS('http://www.w3.org/2000/svg', 'use');
                useElem.setAttributeNS('http://www.w3.org/1999/xlink', 'xlink:href', `#${connection.wallet}`);
                icon.appendChild(useElem);
                const network = document.createElement('div');
                network.classList.add('network');
                network.textContent = chainName[connection.network];
                const address = document.createElement('div');
                address.classList.add('address', 'ml-2');
                address.textContent = connection.address;
                const button = document.createElement('button');
                button.classList.add('dropdown-item', 'd-flex', 'justify-content-between', 'align-items-center');
                button.appendChild(icon);
                button.appendChild(network);
                button.appendChild(address);
                button.id = `${connection.wallet}+${connection.network}+${connection.address}`;
                walletDrowdownMenu.appendChild(button);
            }
            const addNewConnectionButton = document.createElement('div');
            addNewConnectionButton.classList.add('btn', 'btn-primary', 'add-connection', 'wallet-modal-trigger');
            addNewConnectionButton.textContent = 'Add connection';
            addNewConnectionButton.addEventListener('click', (e) => {
                $('#exampleModal').modal('toggle');
            });
            walletDrowdownMenu.appendChild(addNewConnectionButton);
        }
    };

    const walletDrowdownMenu = document.querySelector('.wallet-dropdown-menu');
    const modalWalletSelection = document.querySelector('.modal-body-wallets');
    const walletModalButton = document.querySelectorAll('.wallet-modal-trigger');
    const walletOptions = document.querySelector('.wallet-options');

    walletModalButton.forEach((el) => {
        el.addEventListener('click', (e) => {
            $('#exampleModal').modal('toggle');
        });
    });

    let connectionList = localStorage.getItem('connection-list')
        ? JSON.parse(localStorage.getItem('connection-list'))
        : [];
    let currentConnection = localStorage.getItem('current-connection');
    setupConnectionButton();

    //You should always disable the button that caused the request to be dispatched, while the request is still pending.
    modalWalletSelection.addEventListener('click', (event) => {
        const button = event.target;
        const type = event.target.getAttribute('data-value').split(' ').join('').replace('#', '');
        const wallet = new Wallet(type);
        button.setAttribute('disabled', '');

        wallet
            .connect()
            .then(([ci, cc]) => {
                connectionList = ci;
                currentConnection = cc;
            })
            .catch((error) => {
                console.log(error);
            })
            .finally(() => {
                setupConnectionButton();
                button.removeAttribute('disabled');
                $('#exampleModal').modal('toggle');
            });
    });

    walletDrowdownMenu.addEventListener('click', (event) => {
        const target = event.target.id;
        if (target) {
            currentConnection = target;
            localStorage.setItem('current-connection', currentConnection);
            const chainId = currentConnection.split('+')[1];
            const address = currentConnection.split('+')[2];
            setupHref(chainId, address);
            setupConnectionButton();
        }
    });

    const connectWallet = (walletType) => {
        const wallet = new Wallet(walletType);
        wallet
            .connect()
            .then(([ci, cc]) => {
                connectionList = ci;
                currentConnection = cc;
            })
            .catch((error) => {
                console.log(error);
            })
            .finally(() => {
                const chainId = currentConnection.split('+')[1];
                const address = currentConnection.split('+')[2];
                setupHref(chainId, address);
                setupConnectionButton();
            });
    };

    if (window?.ethereum?.providers?.length) {
        window.ethereum.providers.forEach((p) => {
            p.on('accountsChanged', (accounts) => {
                if (accounts.length) {
                    const walletType = p.isMetaMask ? WALLET.METAMASK : WALLET.COINBASE;
                    connectWallet(walletType);
                }
                //fires when connect wallet or change account
                // Handle the new accounts, or lack thereof.
                // "accounts" will always be an array, but it can be empty.
            });
            p.on('chainChanged', (chainId) => {
                const walletType = p.isMetaMask ? WALLET.METAMASK : WALLET.COINBASE;
                connectWallet(walletType);
                //fires when change chain
                // Handle the new chain.
                // Correctly handling chain changes can be complicated.
                // We recommend reloading the page unless you have good reason not to.
                // window.location.reload();
            });
        });
    } else if (window.ethereum) {
        const walletType = ethereum.isMetaMask ? WALLET.METAMASK : WALLET.COINBASE;
        ethereum.on('accountsChanged', (accounts) => {
            if (accounts.length) {
                connectWallet(walletType);
            }
        });
        ethereum.on('chainChanged', (chainId) => {
            connectWallet(walletType);
        });
    }

    if (window?.phantom?.solana) {
        phantom.solana.on('accountChanged', (publicKey) => {
            connectWallet(WALLET.PHANTOM);
        });
    }
}

document.addEventListener('DOMContentLoaded', setupWalletConnection);
document.addEventListener('DOMContentLoaded', setupWalletConnection);

global.escapeHtml = function (unsafe) {
    return unsafe
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
};

document.addEventListener('DOMContentLoaded', setupWalletConnection);

global.escapeHtml = function (unsafe) {
    return unsafe
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
};

$('document').ready(function () {
    new ClipboardJS('.to-clipboard');
    $('.to-clipboard').tooltip();
    $('.to-clipboard').on('click', function () {
        let it = $(this);
        $(this).attr('data-original-title', 'Copied!').tooltip('show');
        setTimeout(() => {
            $(this).attr('data-original-title', 'Copy');
        }, 200);
    });
});

const getValueFrom = (o, s) => {
    s = s.replace(/\[(\w+)\]/g, '.$1');
    s = s.replace(/^\./, '');
    var a = s.split('.');
    for (var i = 0, n = a.length; i < n; ++i) {
        var k = a[i];
        if (k in o) {
            o = o[k];
        } else {
            return;
        }
    }
    return o;
};

class dataSourceWidget {
    constructor(query, variables, displayed_data, url) {
        this.query = query;
        this.variables = variables;
        this.displayed_data = displayed_data;
        this.setupData = function (json) {
            return 'data' in json ? getValueFrom(json.data, this.displayed_data) : null;
        };
        this.fetcher = function () {
            return fetch(url, {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
                },
                body: JSON.stringify({query: this.query, variables: this.variables}),
                credentials: 'same-origin',
            });
        };
    }
}

global.createLayout = function (dashboard_container, unit, layout_item, name_item) {
    let new_layout_element_container = document.createElement('div');
    new_layout_element_container.style.position = 'absolute';
    new_layout_element_container.style.display = 'flex';
    new_layout_element_container.style.flexDirection = 'column';
    new_layout_element_container.style.border = '1px solid rgba(0, 0, 0, 0.125)';
    new_layout_element_container.style.borderRadius = '0.25rem';
    new_layout_element_container.style.transform = `translate(${layout_item.x * unit.width + 10}px, ${layout_item.y * unit.height + 10}px)`;
    new_layout_element_container.style.width = `${layout_item.w * unit.width - 10}px`;
    new_layout_element_container.style.height = `${layout_item.h * unit.height - 10}px`;
    let title_element = document.createElement('div');
    title_element.style.padding = '0.75rem 1.25rem';
    title_element.style.marginBottom = '0';
    title_element.style.backgroundColor = 'rgba(0, 0, 0, 0.03)';
    title_element.style.borderBottom = '1px solid rgba(0, 0, 0, 0.125)';
    let title = document.createTextNode(name_item);
    title_element.appendChild(title);
    new_layout_element_container.appendChild(title_element);
    let new_layout_element = document.createElement('div');
    new_layout_element.setAttribute('id', layout_item.i);
    new_layout_element.style.height = '100%';
    new_layout_element_container.appendChild(new_layout_element);
    dashboard_container.appendChild(new_layout_element_container);
};

global.createWidget = async function (widgetType, container_id, argsReplace, transferURL) {
    const query = {
        transfers:
            'query transfers($network: evm_network!, $baseCurrency: String!) {\n  EVM(network: $network) {\n    Transfers(\n      where: {Transfer: {Currency: {SmartContract: {is: $baseCurrency}}}}\n      limit: {count: 100}\n      ) {\n      Block {\n        Number\n        Time\n      }\n      Transfer {\n        Currency {\n          Symbol\n        }\n        Receiver\n        Sender\n        Amount\n      }\n      Transaction{\n        Hash\n      }\n    }\n  }\n}\n',
        token_dex_trades:
            'query subscribeTrading($network: evm_network!, $baseCurrency: String!) {\n  EVM(network: $network) {\n    sell: DEXTrades(\n      where: {Trade: {Buy: {Currency: {SmartContract: {is: $baseCurrency}}}}}\n      limit: {count: 100}\n      ) {\n      Block {\n        Time\n        Number\n      }\n      Trade {\n        Sell {\n          Buyer\n          Amount\n          Currency {\n            Symbol\n          }\n        }\n        Buy {\n          Price\n          Amount\n          Currency {\n            Symbol\n          }\n        }\n        Dex {\n          ProtocolName\n          SmartContract\n        }\n      }\n    }\n  }\n}\n',
        pair_dex_trades:
            'query pair(\n  $network: evm_network!\n  $baseCurrency: String!\n  $quoteCurrency: String!\n) {\n  EVM(network: $network) {\n    sell: DEXTrades(\n      where: {\n        Trade: {\n          Sell: { Currency: { SmartContract: { is: $baseCurrency } } }\n          Buy: { Currency: { SmartContract: { is: $quoteCurrency } } }\n        }\n      }\n    ) {\n      Block {\n        Time\n        Number\n      }\n      Trade {\n        Sell {\n          Buyer\n          Amount\n          Currency {\n            Symbol\n          }\n        }\n        Buy {\n          Price\n          Amount\n          Currency {\n            Symbol\n          }\n        }\n        Dex {\n          ProtocolName\n          SmartContract\n        }\n      }\n    }\n    \n    \n  }\n}\n',
    };
    const variables = {};
    const dataFunction = {
        transfers: (data) =>
            data.EVM.Transfers.filter((el) => el.Transfer.Sender !== '0x' && el.Transfer.Receiver !== '0x'),
        token_dex_trades: (data) => data.EVM.sell,
        pair_dex_trades: (data) => data.EVM.sell,
    };
    const displayedData = {
        transfers: 'EVM.Transfers',
        token_dex_trades: 'EVM.sell',
        pair_dex_trades: 'EVM.sell',
    };
    let table = null;

    const getAPIButton = document.createElement('button');
    getAPIButton.classList.add('badge', 'badge-secondary', 'open-btn', 'bg-success', 'get-api');
    getAPIButton.textContent = 'Get Streaming API';
    getAPIButton.onclick = () => {
        let createHiddenField = function (name, value) {
            let input = document.createElement('input');
            input.setAttribute('type', 'hidden');
            input.setAttribute('name', name);
            input.setAttribute('value', value);
            return input;
        };

        let form = document.createElement('form');
        form.setAttribute('method', 'post');
        form.setAttribute('action', transferURL);
        form.setAttribute('target', '_blank');
        form.setAttribute('enctype', 'application/json');
        form.appendChild(createHiddenField('query', JSON.stringify(query[widgetType].replace('query', 'subscription'))));
        form.appendChild(createHiddenField('variables', JSON.stringify(variables)));
        document.body.appendChild(form);
        form.submit();
        document.body.removeChild(form);
    };

    const tabulatorFooter = document.createElement('div');
    tabulatorFooter.classList.add('tabulator-footer');
    tabulatorFooter.appendChild(getAPIButton);

    const defaultTableConfig = {
        layout: 'fitColumns',
        height: '500px',
        rowFormatter: (row) => {
            if (row.getPosition() % 2 === 0) {
                row.getElement().style.backgroundColor = '#f2f2f2';
            }
        },
        headerSort: false,
        footerElement: tabulatorFooter,
    };

    const tableConfig = {
        transfers: {
            ...defaultTableConfig,
            columns: [
                {
                    field: 'Block.Time',
                    title: 'Timestamp',
                    widthGrow: 2,
                    formatter: (cell) => cell.getValue().replace('T', ' ').replace('Z', ''),
                },
                {
                    field: 'Block.Number',
                    title: 'Block',
                    formatter: 'link',
                    formatterParams: {
                        url: (cell) => `${window.location.origin}/${argsReplace.network}/block/${cell.getValue()}`,
                    },
                },
                {
                    field: 'Transfer.Sender',
                    title: 'Sender',
                    formatter: 'link',
                    formatterParams: {
                        url: (cell) => `${window.location.origin}/${argsReplace.network}/address/${cell.getValue()}`,
                    },
                },
                {
                    formatter: (cell, formatterParams) => "<i class='fa fa-sign-in text-success'></i>",
                    width: 40,
                    hozAlign: 'center',
                },
                {
                    field: 'Transfer.Receiver',
                    title: 'Receiver',
                    formatter: 'link',
                    formatterParams: {
                        url: (cell) => `${window.location.origin}/${argsReplace.network}/address/${cell.getValue()}`,
                    },
                },
                {
                    field: 'Transfer.Amount',
                    title: 'Amount',
                    hozAlign: 'right',
                    headerHozAlign: 'right',
                    formatter: (cell) => parseFloat(cell.getValue()).toFixed(4),
                },
                {
                    field: 'Transfer.Currency.Symbol',
                    title: 'Currency',
                },
                {
                    field: 'Transaction.Hash',
                    title: 'Transaction',
                    formatter: (cell, formatterParams) => {
                        return `<a href="${formatterParams.url(cell)}">${formatterParams.label(cell)}</a>`;
                    },
                    formatterParams: {
                        url: (cell) => `${window.location.origin}/${argsReplace.network}/tx/${cell.getValue()}`,
                        label: (cell) => `<i class="fas fa-share-square text-primary mr-1"></i>${cell.getValue()}`,
                    },
                },
            ],
        },
        token_dex_trades: {
            ...defaultTableConfig,
            columns: [
                {
                    field: 'Block.Time',
                    title: 'Timestamp',
                    widthGrow: 2,
                    formatter: (cell) => cell.getValue().replace('T', ' ').replace('Z', ''),
                },
                {
                    field: 'Block.Number',
                    title: 'Block',
                    formatter: 'link',
                    formatterParams: {
                        url: (cell) => `${window.location.origin}/${argsReplace.network}/block/${cell.getValue()}`,
                    },
                },
                {
                    field: 'Trade.Buy.Amount',
                    title: 'Quote amount',
                    hozAlign: 'right',
                    headerHozAlign: 'right',
                    formatter: (cell) => parseFloat(cell.getValue()).toFixed(4),
                },
                {
                    field: 'Trade.Buy.Currency.Symbol',
                    title: 'Quote currency',
                },
                {
                    field: 'Trade.Buy.Price',
                    title: 'Price',
                    widthGrow: 2,
                    formatter: (cell) =>
                        `${parseFloat(cell.getValue()).toFixed(4)} ${cell
                            .getRow()
                            .getCell('Trade.Sell.Currency.Symbol')
                            .getValue()}`,
                },
                {
                    formatter: () => "<i class='fa fa-sign-in text-success'></i>",
                    width: 40,
                    hozAlign: 'center',
                },
                {
                    field: 'Trade.Sell.Amount',
                    title: 'Base amount',
                    hozAlign: 'right',
                    headerHozAlign: 'right',
                    formatter: (cell) => parseFloat(cell.getValue()).toFixed(4),
                },
                {
                    field: 'Trade.Sell.Currency.Symbol',
                    title: 'Base currency',
                },
                {
                    field: 'Trade.Dex.ProtocolName',
                    title: 'Protocol',
                },
                {
                    field: 'Trade.Dex.SmartContract',
                    title: 'Smart contract',
                    formatter: 'link',
                    formatterParams: {
                        url: (cell) => `${window.location.origin}/${argsReplace.network}/smart_contract/${cell.getValue()}`,
                    },
                },
            ],
        },
        pair_dex_trades: {
            ...defaultTableConfig,
            columns: [
                {
                    field: 'Block.Time',
                    title: 'Timestamp',
                    widthGrow: 2,
                    formatter: (cell) => cell.getValue().replace('T', ' ').replace('Z', ''),
                },
                {
                    field: 'Block.Number',
                    title: 'Block',
                    formatter: 'link',
                    formatterParams: {
                        url: (cell) => `${window.location.origin}/${argsReplace.network}/block/${cell.getValue()}`,
                    },
                },
                {
                    field: 'Trade.Buy.Amount',
                    title: 'Quote amount',
                    hozAlign: 'right',
                    headerHozAlign: 'right',
                    formatter: (cell) => parseFloat(cell.getValue()).toFixed(4),
                },
                {
                    field: 'Trade.Buy.Currency.Symbol',
                    title: 'Quote currency',
                },
                {
                    field: 'Trade.Buy.Price',
                    title: 'Price',
                    widthGrow: 2,
                    formatter: (cell) =>
                        `${parseFloat(cell.getValue()).toFixed(4)} ${cell
                            .getRow()
                            .getCell('Trade.Sell.Currency.Symbol')
                            .getValue()}`,
                },
                {
                    formatter: () => "<i class='fa fa-sign-in text-success'></i>",
                    width: 40,
                    hozAlign: 'center',
                },
                {
                    field: 'Trade.Sell.Amount',
                    title: 'Base amount',
                    hozAlign: 'right',
                    headerHozAlign: 'right',
                    formatter: (cell) => parseFloat(cell.getValue()).toFixed(4),
                },
                {
                    field: 'Trade.Sell.Currency.Symbol',
                    title: 'Base currency',
                },
                {
                    field: 'Trade.Dex.ProtocolName',
                    title: 'Protocol',
                },
                {
                    field: 'Trade.Dex.SmartContract',
                    title: 'Smart contract',
                    formatter: 'link',
                    formatterParams: {
                        url: (cell) => `${window.location.origin}/${argsReplace.network}/smart_contract/${cell.getValue()}`,
                    },
                },
            ],
        },
    };

    const payload = {
        query: query[widgetType].replace('query', 'subscription'),
        variables,
    };
    if (argsReplace) {
        for (let arg in argsReplace) {
            payload.variables[arg] = argsReplace[arg] === 'ethereum' ? 'eth' : argsReplace[arg];
        }
    }
    const сlient = createClient({
        url: 'wss://streaming.bitquery.io/graphql',
        shouldRetry: () => false,
    });
    const ds = new dataSourceWidget(
        query[widgetType],
        variables,
        displayedData[widgetType],
        'https://streaming.bitquery.io/graphql'
    );
    table = await tableWidgetRenderer(ds, tableConfig[widgetType], container_id);
    сlient.subscribe(payload, {
        next: ({data}) => {
            const tableLength = 50;
            const filteredData = dataFunction[widgetType](data);
            const currentData = table.getData();
            if (filteredData.length < tableLength) {
                const newData = [...filteredData, ...currentData.slice(0, tableLength - filteredData.length)];
                table.replaceData(newData);
            } else {
                table.replaceData(filteredData.slice(0, tableLength));
            }
        },
        error: () => console.log('error'),
        complete: () => console.log('complete'),
    });
};

global.createDashboard = function (dashboard_url, container_id, argsReplace) {
    const dashboard_container = document.getElementById(container_id);
    const unit = {
        height: 105,
        width: dashboard_container.clientWidth / 12,
    };
    $.get(`/proxy_dbcode/${dashboard_url}`, function (data) {
        const layout = JSON.parse(data.layout);
        const height_units = Math.max(...layout.map((i) => i.y + i.h));
        const container_height = height_units * unit.height;
        dashboard_container.style.height = `${container_height}px`;
        data.widgets.forEach((widget) => {
            createLayout(
                dashboard_container,
                unit,
                layout.find((item) => item.i === widget.query_index),
                widget.name || ''
            );
            let args = JSON.parse(widget.variables);
            if (argsReplace && widget.widget_id !== 'block.content') {
                for (let arg in argsReplace) {
                    args[arg] = argsReplace[arg];
                }
            }
            args = JSON.stringify(args);
            let ds = new dataSourceWidget(widget.query, args, widget.displayed_data, '/proxy_graphql');
            if (widget.widget_id === 'block.content') {
                const widgetMD = JSON.parse(widget.config).content;
                const parsedMD = micromark(widgetMD);
                const container = document.getElementById(widget.query_index);
                container.style.padding = '10px';
                container.insertAdjacentHTML('afterbegin', parsedMD);
            } else {
                widgetRenderer[widget.widget_id](ds, JSON.parse(widget.config), widget.query_index);
            }
        });
    });
};

global.reportRange = function (selector, from, till, i18n) {
    var properties = {
        start: undefined,
        end: undefined,
        i18n: i18n,
        ranges: {},
        cbs: [],
    };

    this.cancel = false;
    this.click = false;
    let his = this;


    moment.locale('en');


    if (from == null && till == null) {
        $(selector).find('span').html(i18n.all_time);
    }

    if (from != null) {
        properties.start = moment(from);
    }
    if (till != null) {
        properties.end = moment(till);
    }

    function set_reportrange(start, end) {
        $(selector)
            .find('span')
            .html(start.format(i18n.format) + ' - ' + end.format(i18n.format));
    }

    // properties.ranges[i18n.all_time] = [null, null];
    properties.ranges[i18n.today] = [moment(), moment()];
    properties.ranges[i18n.yesterday] = [moment().subtract(1, 'days'), moment().subtract(1, 'days')];
    properties.ranges[i18n.last7] = [moment().subtract(6, 'days'), moment()];
    properties.ranges[i18n.last30] = [moment().subtract(29, 'days'), moment()];
    properties.ranges[i18n.this_month] = [moment().startOf('month'), moment().endOf('month')];
    properties.ranges[i18n.last_month] = [
        moment().subtract(1, 'month').startOf('month'),
        moment().subtract(1, 'month').endOf('month'),
    ];

    $(selector).daterangepicker(
        {
            showDropdowns: true,
            minYear: 2000,
            maxYear: parseInt(moment().format('YYYY'), 10),
            startDate: properties.start,
            endDate: properties.end,
            maxDate: moment(),
            opens: 'left',
            linkedCalendars: false,
            locale: {
                cancelLabel: i18n.clear,
                applyLabel: i18n.apply,
                customRangeLabel: i18n.custom_range,
            },
            ranges: properties.ranges,
        },
        set_reportrange
    );

    $(selector).on('cancel.daterangepicker', function (ev, picker) {
        $(selector).find('span').html(i18n.all_time);
        $('.daterangepicker .ranges li').addClass('active');
    });

    $(selector).on('show.daterangepicker', function (ev, picker) {
        if ($(selector).find('span').html() == i18n.all_time) {
            picker.container.find('.ranges li').removeClass('active');
            picker.container.find('.ranges li').first().addClass('active');
        }
    });

    if (from != null && till != null) {
        set_reportrange(properties.start, properties.end);
    }

    function changeUrl(from, till) {
        $('a[data-changeurl="true"]').each(function () {
            let href = $(this).prop('href').split('?');
            let up = href[1] ? $.urlParams(href[1].split('&')) : {};
            if (from && till) {
                up['from'] = from;
                up['till'] = till;
            } else {
                delete up.from;
                delete up.till;
            }
            $(this).prop('href', href[0] + ($.param(up) ? '?' + $.param(up) : ''));
        });
    }

    $(window).on('popstate', function (e) {
        var up = $.urlParams(window.location.search.substr(1).split('&'));
        if (up.from && up.till) {
            $(selector).data('daterangepicker').setStartDate(moment(up.from));
            $(selector).data('daterangepicker').setEndDate(moment(up.till));
            set_reportrange(moment(up.from), moment(up.till));
            $.each(properties.cbs, function () {
                this(moment(up.from).format('YYYY-MM-DD'), moment(up.till).format('YYYY-MM-DD'), undefined);
            });
            changeUrl(up.from, up.till);
        } else {
            $(selector).find('span').html(i18n.all_time);
            $.each(properties.cbs, function () {
                this(null, null, 'clear');
                changeUrl(null, null);
            });
        }
    });

    properties.change = function (cb) {
        properties.cbs.push(cb);

        $($(selector).data().daterangepicker.container.find('.ranges li')[1]).on('click', function (ev) {
            if (his.click == false) {
                his.click = true;
                $(this).click();
                his.click = false;
            }
        });
        $(selector).on('apply.daterangepicker', function (ev, picker) {
            if (!picker.startDate._isValid && !picker.endDate._isValid && his.cancel == false) {
                his.cancel = true;
                setTimeout(function () {
                    picker.startDate = moment();
                    picker.endDate = moment();
                }, 500);
                $(selector).trigger('cancel.daterangepicker', ev, picker);
            } else if (his.cancel === true) {
                his.cancel = false;
            } else {
                var start = picker.startDate.format('YYYY-MM-DD'),
                    end = picker.endDate.format('YYYY-MM-DDT23:59:59'),
                    endToParam = picker.endDate.format('YYYY-MM-DD'),
                    clear_date = undefined;
                cb(start, end, clear_date);
                $(selector)
                    .find('span')
                    .html(picker.startDate.format(i18n.format) + ' - ' + picker.endDate.format(i18n.format));
                let url = location.origin + location.pathname;
                if (location.href != url + '?' + $.param(_.merge($.urlParams, {from: start, till: endToParam}))) {
                    history.pushState(
                        {
                            data: {},
                            url: url,
                        },
                        document.title,
                        url + '?' + $.param(_.merge($.urlParams, {from: start, till: endToParam}))
                    );
                    changeUrl(start, endToParam);
                }
            }
        });
        $(selector).on('cancel.daterangepicker', function (ev, picker) {
            var start = null,
                end = null,
                clear_date = 'clear';
            cb(start, end, clear_date);
            let url = location.origin + location.pathname;
            let params = $.urlParams;
            delete params.from;
            delete params.till;
            if (location.href != url + ($.param(params) ? '?' + $.param(params) : '')) {
                history.pushState(
                    {
                        data: {},
                        url: url,
                    },
                    document.title,
                    url + ($.param(params) ? '?' + $.param(params) : '')
                );
                changeUrl(start, end);
            }
        });
    };

    return properties;
};

global.search = function (selector) {
    let form = $(selector);
    let is_find = true;

    form.find('input[name="query"]').keyup(function () {
        let it = $(this);
        let f = it.parents('form').first();
        // form.find('input').not(this).val($(this).val());
        if (it.val() == '') {
            is_find = false;
            f.find('button').addClass('disabled');
        } else {
            is_find = true;
            f.find('button').removeClass('disabled');
        }
    });

    form.find('input[name="query"]').change(function () {
        $(this).keyup();
    });
    form.find('input[name="query"]').keyup();

    form.submit(function () {
        let it = $(this);
        let net = it.find('input[type="hidden"][name="network"]');
        let btn = it.find('button').first();

        if (!net[0] && btn.data('network') != '') {
            append_network(btn.data('network'));
        }
        return is_find;
    });

    form.find('.search-form-type').click(function () {
        let it = $(this);
        append_network(it.data('network'));
        it.parents('form').first().submit();
        return false;
    });

    function append_network(network) {
        $('<input />').attr('type', 'hidden').attr('name', 'network').attr('value', network).appendTo(selector);
    }
};

(function ($) {
    $.urlParams = function (paramsArray = window.location.search.substr(1).split('&')) {
        var params = {};

        for (var i = 0; i < paramsArray.length; ++i) {
            var param = paramsArray[i].split('=', 2);

            if (param.length !== 2) continue;

            params[param[0]] = decodeURIComponent(param[1].replace(/\+/g, ' '));
        }

        return params;
    };
    $.urlParamsToArray = (function (obj) {
        var p = [];
        $.each(obj, function (k, v) {
            p.push({name: k, value: v});
        });
        return p;
    })($.urlParams);
})($);

function compactDataArray(arr) {
    var data = [];
    $.each(arr, function () {
        this.value != '' ? data.push(this) : '';
    });
    return data;
}

global.dateRangeReportFormat = function (from, till, network) {
    if (networksLimitedDates(network)) {
        return '%Y-%m-%d';
    } else if (from) {
        var tillp = till ? Date.parse(till) : Date.now();
        if ((tillp - Date.parse(from)) / (24 * 3600 * 1000) > 100) {
            return '%Y-%m';
        } else {
            return '%Y-%m-%d';
        }
    } else {
        return '%Y-%m';
    }
};

global.networksLimitedDates = function (network) {
    return ['celo_alfajores', 'celo_baklava', 'celo_rc1', 'medalla', 'eth2', 'ethpow'].indexOf(network) >= 0;
};

global.queryWithTimeRange = function (rr, query, from, till, params) {
    function draw(start, end) {
        var dateFormat = dateRangeReportFormat(start, end, params && params.network);
        var data = Object.assign({}, params, {
            from: start,
            till: end && !end.includes('T') ? end + 'T23:59:59' : end,
            dateFormat: dateFormat,
            offset: 0,
            limit: 10,
        });
        query.request(data);
    }

    draw(from, till);
    rr.change(draw);
};

global.renderWithTime = function (variables = {}, from, till, f) {

    function draw(start, end) {

        const dateFormat = dateRangeReportFormat(start, end);
        const data = Object.assign({}, {
            from: start,
            till: end ? end.split('T')[0] : start,
            dateFormat: dateFormat,
        });
        const from = new Date(data.from);
        const till = new Date(data.till);

        if (from > till) {
            const middleDate = new Date(till.getTime() + (from.getTime() - till.getTime()) / 2);
            data.date_middle = middleDate.toISOString().split('T')[0];
        } else if (till > from) {
            const middleDate = new Date(from.getTime() + (till.getTime() - from.getTime()) / 2);
            data.date_middle = middleDate.toISOString().split('T')[0];
        } else {
            data.date_middle = data.from;
        }

        const resultVariables = {...variables, ...data}
        f(resultVariables)

    }

    draw(from, till);
    rr.change(draw);
}