export default class WidgetConfig {
    static getBlockchainInfo() {
        return [
            {
                tag: 'eth',
                chainId: '1',
                network: 'ethereum',
                name: 'Ethereum Mainnet',
                family: 'ethereum',
                platform: 'Smart Contract',
                currency: 'ETH',
                icon: 'eth.svg',
                eap: false,
                innovation: true,
                blockProducerName: 'Validator',
            },
            {
                tag: 'base',
                chainId: '8453',
                network: 'base',
                name: 'Base',
                family: 'ethereum',
                platform: 'Smart Contract',
                currency: 'ETH',
                icon: 'currency/base.svg',
                eap: false,
                innovation: true,
                blockProducerName: 'Validator',
            },
            {
                tag: 'bsc',
                network: 'bsc',
                chainId: '56',
                name: 'Binance Smart Chain Mainnet',
                family: 'ethereum',
                platform: 'Smart Contract',
                currency: 'BNB',
                icon: 'bnb.svg',
                start: Date.parse('2020-08-29'),
                eap: false,
                innovation: true,
                blockProducerName: 'Validator',
            },
            {
                tag: 'arbitrum',
                chainId: '42161',
                network: 'arbitrum',
                streaming: 'arbitrum',
                name: 'Arbitrum Mainnet',
                family: 'ethereum',
                platform: 'Smart Contract',
                currency: 'ETH',
                eap: false,
                icon: 'currency/arbitrum.svg',
                blockProducerName: 'Validator',
            },
            {
                tag: 'matic',
                chainId: '137',
                network: 'matic',
                streaming: 'matic',
                name: 'Matic',
                family: 'ethereum',
                platform: 'Smart Contract',
                currency: 'ETH',
                eap: true,
                icon: 'matic.svg',
                blockProducerName: 'Validator',
            },
            {
                tag: 'optimism',
                chainId: '10',
                network: 'optimism',
                streaming: 'optimism',
                name: 'Optimism (OP Mainnet)',
                family: 'ethereum',
                platform: 'Smart Contract',
                currency: 'ETH',
                icon: 'currency/optimism.svg',
                use_eap: true,
            },
            {
                tag: 'opbnb',
                chainId: '204',
                network: 'opbnb',
                streaming: 'opbnb',
                name: 'opBNB',
                family: 'ethereum',
                platform: 'Smart Contract',
                currency: 'BNB',
                icon: 'currency/opbnb.svg',
                use_eap: true,
            },
        ];
    }

    static getBlockchainMap() {
        return this.getBlockchainInfo().reduce((map, blockchain) => {
            map[blockchain.chainId] = blockchain;
            return map;
        }, {});
    }

    static getProperty(chainId, property) {
        const blockchain = this.getBlockchainMap()[chainId];
        return blockchain ? blockchain[property] : null;
    }

    static getNetwork(chainId) {
        return this.getProperty(chainId, 'network');
    }

    static getCurrency(chainId) {
        return this.getProperty(chainId, 'currency');
    }

    static getBlockProducerName(chainId) {
        return this.getProperty(chainId, 'blockProducerName');
    }

    static getName(chainId) {
        return this.getProperty(chainId, 'name');
    }
}
