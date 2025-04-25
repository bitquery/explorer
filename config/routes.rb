Rails.application.routes.draw do
  mount Yabeda::Prometheus::Exporter => "/metrics"

  # Redirect unsupported locales to root
  get '/:locale/*path', to: redirect { |params, request|
    if ['ru', 'zh'].include?(params[:locale])
      new_path = request.path.gsub("/#{params[:locale]}", '')
      "https://#{request.host}#{new_path}"
    else
      request.path
    end
  }, constraints: { locale: /ru|zh/ }

  scope "(:locale)", constraints: lambda { |request|
    !request.params[:locale] || I18n.locale_available?(request.params[:locale].to_sym)
  } do

    # Ethereum family
    BLOCKCHAINS.select { |b| b[:family] == "ethereum" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "ethereum/network#blocks"
          get ":blockchain/address/:address/graph", to: "ethereum/address#money_flow"
          get ":blockchain/address/:address", to: "ethereum/address#show"
          get ":blockchain/address/:address/nft_address", to: "ethereum/address#show"

          get ":blockchain/smart_contract/:address/graph", to: "ethereum/smart_contract#money_flow"
          get ":blockchain/smart_contract/:address", to: "ethereum/smart_contract#show"

          get ":blockchain/token/:address/id/:id", to: "ethereum/token#show_nft_id"
          get ":blockchain/token/:smart_contract/trading", to: "ethereum/token#show"
          get ":blockchain/token/:address", to: "ethereum/token#show"

          get ":blockchain/tx/:hash", to: "ethereum/tx#show"
          get ":blockchain/txs", to: "ethereum/tx_list#index"

          get ":blockchain/block/:block", to: "ethereum/block#show"

          get ":blockchain/method/:signature", to: "ethereum/method#show"

          get ":blockchain/event/:signature", to: "ethereum/event#show"

          get ":blockchain/dex_protocol/:protocol_name", to: "ethereum/dex_protocol#statistics", format: false
          get ":blockchain/dex/:exchange", to: "ethereum/dex#statistics"

          get ":blockchain/sitemap/index.xml", to: "ethereum/sitemap#index"
          get ":blockchain/tokenpair/:token1/:token2", to: "ethereum/token_pair#trading_view"
          get ":blockchain/tokenpair/:token1/:token2/trading_view", to: "ethereum/token_pair#trading_view"
          get ":blockchain/tokenpair/:token1/:token2/last_trades", to: "ethereum/token_pair#last_trades"
        end
      end
    end

    # Ethereum 2 family
    BLOCKCHAINS.select { |b| b[:family] == "ethereum2" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "ethereum2/network#blocks"
          get ":blockchain/sitemap/index.xml", to: "ethereum2/sitemap#index"

          get ":blockchain/validator/:index", to: "ethereum2/validator#show"
          get ":blockchain/block/:block", to: "ethereum2/block#show"
        end
      end
    end

    # Tron family
    BLOCKCHAINS.select { |b| b[:family] == "tron" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "tron/network#blocks"
          get ":blockchain/address/:address/graph", to: "tron/address#money_flow"
          get ":blockchain/address/:address", to: "tron/address#show"

          get ":blockchain/smart_contract/:address/graph", to: "tron/smart_contract#money_flow"
          get ":blockchain/smart_contract/:address", to: "tron/smart_contract#show"

          get ":blockchain/trc20token/:address", to: "tron/trc20token#show"
          get ":blockchain/trc10token/:address", to: "tron/trc10token#show"

          get ":blockchain/tx/:hash", to: "tron/tx#show"
          get ":blockchain/txs", to: "tron/tx_list#index"

          get ":blockchain/block/:block", to: "tron/block#show"

          get ":blockchain/method/:signature", to: "tron/method#show"
          get ":blockchain/event/:signature", to: "tron/event#show"

          get ":blockchain/dex_protocol/:protocol_name", to: "tron/dex_protocol#statistics"
          get ":blockchain/dex/:exchange", to: "tron/dex#statistics"

          get ":blockchain/sitemap/index.xml", to: "tron/sitemap#index"
        end
      end
    end

    # EOS family
    BLOCKCHAINS.select { |b| b[:family] == "eos" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "eos/network#blocks"
          get ":blockchain/address/:address", to: "eos/address#show"
          get ":blockchain/address/:address/money_flow", to: "eos/address#money_flow"

          get ":blockchain/smart_contract/:address", to: "eos/smart_contract#show"
          get ":blockchain/smart_contract/:address/money_flow", to: "eos/smart_contract#money_flow"

          get ":blockchain/token/:address", to: "eos/token#show"
          get ":blockchain/token/:address/money_flow", to: "eos/token#money_flow"

          get ":blockchain/tx/:hash", to: "eos/tx#show"
          get ":blockchain/txs", to: "eos/tx_list#index"

          get ":blockchain/block/:block", to: "eos/block#show"
          get ":blockchain/height/:height", to: "eos/height#blocks"

          get ":blockchain/method/:signature", to: "eos/method#show"
          get ":blockchain/event/:signature", to: "eos/event#show"

          get ":blockchain/sitemap/index.xml", to: "eos/sitemap#index"
        end
      end
    end

    # Conflux family
    BLOCKCHAINS.select { |b| b[:family] == "conflux" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "conflux/network#blocks"
          get ":blockchain/address/:address/graph", to: "conflux/address#money_flow"
          get ":blockchain/address/:address", to: "conflux/address#show"

          get ":blockchain/smart_contract/:address/graph", to: "conflux/smart_contract#money_flow"
          get ":blockchain/smart_contract/:address", to: "conflux/smart_contract#show"

          get ":blockchain/token/:address/graph", to: "conflux/token#money_flow"
          get ":blockchain/token/:address", to: "conflux/token#show"

          get ":blockchain/tx/:hash", to: "conflux/tx#show"
          get ":blockchain/txs", to: "conflux/tx_list#index"

          get ":blockchain/block/:hash", to: "conflux/block#show"

          get ":blockchain/method/:signature", to: "conflux/method#show"
          get ":blockchain/event/:signature", to: "conflux/event#show"

          get ":blockchain/sitemap/index.xml", to: "conflux/sitemap#index"
        end
      end
    end

    # Hedera family
    BLOCKCHAINS.select { |b| b[:family] == "hedera" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "hedera/network#transactions"
          get ":blockchain/tx/:hash", to: "hedera/tx#show"
          get ":blockchain/topics/:topic_id", to: "hedera/topics#show"
          get ":blockchain/accounts/:account_id", to: "hedera/accounts#show"
          get ":blockchain/nodes/:node_account", to: "hedera/nodes#show"
          get ":blockchain/payers/:payer_account", to: "hedera/payers#show"
          get ":blockchain/contracts/:contract_id", to: "hedera/contracts#show"
          get ":blockchain/sitemap/index.xml", to: "hedera/sitemap#index"
        end
      end
    end

    # Binance family
    BLOCKCHAINS.select { |b| b[:family] == "binance" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "binance/network#blocks"
          get ":blockchain/address/:address/graph", to: "binance/address#money_flow"
          get ":blockchain/address/:address", to: "binance/address#show"
          get ":blockchain/order/:order", to: "binance/order#statuses"
          get ":blockchain/token/:symbol", to: "binance/token#show"
          get ":blockchain/tx/:hash", to: "binance/tx#show"
          get ":blockchain/txs", to: "binance/tx_list#index"
          get ":blockchain/block/:block", to: "binance/block#show"
          get ":blockchain/sitemap/index.xml", to: "binance/sitemap#index"
        end
      end
    end

    # Bitcoin family
    BLOCKCHAINS.select { |b| b[:family] == "bitcoin" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "bitcoin/network#blocks"
          get ":blockchain/address/:address/graph", to: "bitcoin/address#money_flow"
          get ":blockchain/address/:address", to: "bitcoin/address#show"
          get ":blockchain/tx/:hash", to: "bitcoin/tx#show"
          get ":blockchain/txs", to: "bitcoin/tx_list#index"
          get ":blockchain/block/:block", to: "bitcoin/block#show"
          get ":blockchain/sitemap/index.xml", to: "bitcoin/sitemap#index"
        end
      end
    end

    # Cardano family
    BLOCKCHAINS.select { |b| b[:family] == "cardano" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "cardano/network#blocks"
          get ":blockchain/address/:address/graph", to: "cardano/address#money_flow"
          get ":blockchain/address/:address", to: "cardano/address#show"

          get ":blockchain/tx/:hash", to: "cardano/tx#show"
          get ":blockchain/txs", to: "cardano/tx_list#index"

          get ":blockchain/block/:block", to: "cardano/block#show"

          get ":blockchain/sitemap/index.xml", to: "cardano/sitemap#index"
        end
      end
    end

    # Filecoin family
    BLOCKCHAINS.select { |b| b[:family] == "filecoin" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "filecoin/network#blocks"
          get ":blockchain/message/:hash", to: "filecoin/message#show"
          get ":blockchain/message/:hash/transfers", to: "filecoin/message#transfers"

          get ":blockchain/address/:address/graph", to: "filecoin/address#money_flow"
          get ":blockchain/address/:address", to: "filecoin/address#show"

          get ":blockchain/tx/:hash", to: "filecoin/tx#show"
          get ":blockchain/txs", to: "filecoin/tx_list#index"

          get ":blockchain/height/:height", to: "filecoin/height#blocks"

          get ":blockchain/sitemap/index.xml", to: "filecoin/sitemap#index"
        end
      end
    end

    # Algorand family
    BLOCKCHAINS.select { |b| b[:family] == "algorand" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "algorand/network#blocks"
          get ":blockchain/address/:address/graph", to: "algorand/address#money_flow"
          get ":blockchain/address/:address", to: "algorand/address#show"

          get ":blockchain/smart_contract/:address/graph", to: "algorand/smart_contract#money_flow"
          get ":blockchain/smart_contract/:address", to: "algorand/smart_contract#show"

          get ":blockchain/token/:id", to: "algorand/token#show"

          get ":blockchain/tx/:hash", to: "algorand/tx#show"
          get ":blockchain/txs", to: "algorand/tx_list#index"

          get ":blockchain/block/:block", to: "algorand/block#show"

          get ":blockchain/sitemap/index.xml", to: "algorand/sitemap#index"
        end
      end
    end

    # Solana family
    BLOCKCHAINS.select { |b| b[:family] == "solana" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "solana/network#blocks"

          get ":blockchain/block/:block_id", to: "solana/block#show"

          get ":blockchain/tx/:hash", to: "solana/tx#show"

          get ":blockchain/address/:address", to: "solana/address#show"

          get ":blockchain/sitemap/index.xml", to: "solana/sitemap#index"
        end
      end
    end

    # Elrond family
    BLOCKCHAINS.select { |b| b[:family] == "elrond" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "elrond/network#shards"

          get ":blockchain/tx/:hash", to: "elrond/tx#show"

          get ":blockchain/call_result/:hash", to: "elrond/call_result#show"

          get ":blockchain/block/:hash", to: "elrond/block#show"

          get ":blockchain/miniblocks/:hash", to: "elrond/miniblocks#show"

          get ":blockchain/address/:address", to: "elrond/address#show"

          get ":blockchain/validators/:hash", to: "elrond/validators#show"

          get ":blockchain/shards/:id", to: "elrond/shards#show"

          get ":blockchain/sitemap/index.xml", to: "elrond/sitemap#index"
        end
      end
    end

    # Cosmos family
    BLOCKCHAINS.select { |b| b[:family] == "cosmos" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "cosmos/network#blocks"

          get ":blockchain/address/:address/graph", to: "cosmos/address#money_flow"
          get ":blockchain/address/:address", to: "cosmos/address#show"

          get ":blockchain/tx/:hash", to: "cosmos/tx#show"

          get ":blockchain/height/:height", to: "cosmos/height#blocks"

          get ":blockchain/sitemap/index.xml", to: "cosmos/sitemap#index"
        end
      end
    end

    # Flow family
    BLOCKCHAINS.select { |b| b[:family] == "flow" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "flow/network#blocks"

          get ":blockchain/tx/:hash", to: "flow/tx#show"

          get ":blockchain/block/:block", to: "flow/block#show"

          get ":blockchain/collections/:hash", to: "flow/collections#show"

          get ":blockchain/address/:address", to: "flow/address#show"

          get ":blockchain/sitemap/index.xml", to: "flow/sitemap#index"
        end
      end
    end

    # Stellar family
    BLOCKCHAINS.select { |b| b[:family] == "stellar" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "stellar/network#blocks"

          get ":blockchain/address/:address", to: "stellar/address#show"

          get ":blockchain/tx/:hash", to: "stellar/tx#show"

          get ":blockchain/block/:block", to: "stellar/block#show"

          get ":blockchain/token/:address", to: "stellar/token#show"

          get ":blockchain/sitemap/index.xml", to: "stellar/sitemap#index"
        end
      end
    end

    # Ripple family
    BLOCKCHAINS.select { |b| b[:family] == "ripple" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "ripple/network#blocks"

          get ":blockchain/address/:address", to: "ripple/address#show"

          get ":blockchain/tx/:hash", to: "ripple/tx#show"

          get ":blockchain/block/:block", to: "ripple/block#show"

          get ":blockchain/token/:address", to: "ripple/token#show"

          get ":blockchain/sitemap/index.xml", to: "ripple/sitemap#index"
        end
      end
    end

    # Tezos family
    BLOCKCHAINS.select { |b| b[:family] == "tezos" }.each do |blockchain|
      constraints blockchain: blockchain[:network] do
        defaults network: blockchain do
          get ":blockchain", to: "tezos/network#blocks"
          get ":blockchain/address/:address/money_flow", to: "tezos/address#money_flow"
          get ":blockchain/address/:address", to: "tezos/address#show"
          get ":blockchain/address/:address/balances", to: "tezos/address#balances"
          get ":blockchain/tx/:hash", to: "tezos/tx#show"
          get ":blockchain/height/:height", to: "tezos/height#blocks"
          get ":blockchain/sitemap/index.xml", to: "tezos/sitemap#index"
        end
      end
    end

    # Miscellaneous routes
    match "search(/:query)", to: "search#show", via: %i[get post], as: "search", constraints: { query: %r{[^/]+} }
    post "proxy_graphql", to: "proxy_graphql#index", defaults: { format: :json }
    post "proxy_streaming_graphql", to: "proxy_streaming_graphql#index", defaults: { format: :json }
    post "proxy_eap_graphql", to: "proxy_eap_graphql#index", defaults: { format: :json }
    get "proxy_dbcode/:dashbord_url", to: "proxy_dbcode#index", defaults: { format: :json }

    get "platform/index", to: "home#index"
    get "platform/about", to: "home#about"
    get "platform/contact", to: "home#contact"

    get "graphql", to: "utility#graphql"
    get "graphql/reset", to: "utility#graphql"

    root "home#index"

    get "sitemap.xml", to: "sitemaps#index"
    get "robots.txt", to: "sitemaps#robots"
    get "*path", to: "utility#errors"
  end
end
