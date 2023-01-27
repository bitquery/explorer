const WALLET = {
	METAMASK: 'metamask',
	PHANTOM: 'phantom',
	EXODUS: 'exodus',
	COINBASE: 'coinbase'
}

const getProvider = (type) => {
	let phantom = undefined
	if (window?.phantom?.solana?.isPhantom && type === WALLET.PHANTOM) {
		phantom = window.phantom.solana
	} else {
		if (window?.coinbaseSolana && type === WALLET.COINBASE) {
			phantom = window.coinbaseSolana
		}
	}
	let ethereum = undefined
	if (window.ethereum?.providers?.length) {
		window.ethereum.providers.forEach(async p => {
			if (p.isMetaMask && type === WALLET.METAMASK) {
				ethereum = p
			}
			if (p.isCoinbaseWallet && type === WALLET.COINBASE) {
				ethereum = p
			}
		})
	} else {
		ethereum = window.ethereum
	}
	return {
		phantom, ethereum
	}
}

export class Wallet {
	constructor(type) {
		if (type === WALLET.METAMASK) {
			return new MetamaskWallet()
		} else if (type === WALLET.PHANTOM) {
			return new PhantomWallet()
		} else if (type === WALLET.COINBASE) {
			return new CoinbaseWallet()
		}
	}
	connect(wallet, network, address) {
		let connectionList = localStorage.getItem('connection-list') || []
		if (connectionList?.length) {
			connectionList = JSON.parse(connectionList)
		}
		connectionList.push({ wallet, network, address })
		connectionList = [...new Map(connectionList.map(v => [JSON.stringify(v), v])).values()]
		localStorage.setItem(
			'connection-list',
			JSON.stringify(connectionList)
		)
		const currentConnection = `${wallet}+${network}+${address}`
		localStorage.setItem('current-connection', currentConnection)
		return [connectionList, currentConnection]
	}
}

class MetamaskWallet extends Wallet {
	provider = getProvider(WALLET.METAMASK)
	async connect() {
		try {
			const accounts = await this.provider.ethereum.request({ method: 'eth_requestAccounts' })
			const chainID = await this.provider.ethereum.request({ method: 'eth_chainId' })
			const connectionList = super.connect(WALLET.METAMASK, chainID, accounts[0])
			return connectionList
		} catch (error) {
			throw new Error(error)
		}
	}
}

class PhantomWallet extends Wallet {
	provider = getProvider(WALLET.PHANTOM)
	async connect() {
		try {
			const resp = await this.provider.phantom.connect()
			const address = resp.publicKey.toString()
			const connectionList = super.connect(WALLET.PHANTOM, 'solana', address)
			return connectionList
		} catch (error) {
			throw new Error(error)
		}
	}
}

class CoinbaseWallet extends Wallet {
	provider = getProvider(WALLET.COINBASE)
	async connect() {
		try {
			const accounts = await this.provider.ethereum.request({ method: 'eth_requestAccounts' })
			const chainID = await this.provider.ethereum.request({ method: 'eth_chainId' })
			const connectionList = super.connect(WALLET.COINBASE, chainID, accounts[0])
			return connectionList
		} catch (error) {
			throw new Error(error)
		}
	}
}
