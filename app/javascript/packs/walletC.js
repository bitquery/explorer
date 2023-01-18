const WALLET = {
	METAMASK: 'metamask',
	PAHNTOM: 'phantom',
	EXODUS: 'exodus'
}
const chainName = {
	0x1: 'Ethereum',
	10: 'Optimism',
	25: 'Cronos',
	56: 'BNB Chain',
	137: 'Poligon'
}

export class Wallet {
	constructor(type) {
		if (type === WALLET.METAMASK) {
			return new MetamaskWallet()
		} else if (type === WALLET.PAHNTOM) {
			return new PhantomWallet()
		} else if (type === WALLET.EXODUS) {
			return new ExodusWallet()
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
	async connect() {
		try {
			const accounts = await ethereum.request({ method: 'eth_requestAccounts' })
			const chainID = await ethereum.request({ method: 'eth_chainId' })
			const connectionList = super.connect(WALLET.METAMASK, chainID, accounts[0])
			return connectionList
		} catch (error) {
			throw new Error(error)
		}
	}
	
}
