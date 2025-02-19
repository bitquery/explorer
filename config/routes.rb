Rails.application.routes.draw do
  mount Yabeda::Prometheus::Exporter => "/metrics"
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

    BLOCKCHAINS.select { |b| b[:family] == "ethereum" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/nft_address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/smart_contract/:address/graph", to: "#{blockchain[:family]}/smart_contract#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address/:action", to: "#{blockchain[:family]}/smart_contract#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address", to: "#{blockchain[:family]}/smart_contract#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      # get ":blockchain/token/:address/graph", to: "#{blockchain[:family]}/token#money_flow",
      #     constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      # get ":blockchain/token/:address/:action", to: "#{blockchain[:family]}/token#:action",
      #     constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      # get ":blockchain/token/:address", to: "#{blockchain[:family]}/token#show",
      #     constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      #
      # get ":blockchain/token/:address/id/:id", to: "#{blockchain[:family]}/token#show_nft_id",
      #     constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      # get ":blockchain/token/:smart_contract/nft_smart_contract", to: "#{blockchain[:family]}/token#show",
      #     constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      # get ":blockchain/token/:smart_contract/trading", to: "#{blockchain[:family]}/token#show",
      #     constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/token/:address/:action", to: "#{blockchain[:family]}/token#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:address", to: "#{blockchain[:family]}/token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/token/:address/id/:id", to: "#{blockchain[:family]}/token#show_nft_id",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:smart_contract/trading", to: "#{blockchain[:family]}/token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/method/:signature/:action", to: "#{blockchain[:family]}/method#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/method/:signature", to: "#{blockchain[:family]}/method#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/event/:signature/:action", to: "#{blockchain[:family]}/event#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/event/:signature", to: "#{blockchain[:family]}/event#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/dex_protocol/:protocol_name/:action", to: "#{blockchain[:family]}/dex_protocol#:action",
          constraints: { blockchain: blockchain[:network], protocol_name: %r{[^/]+} }, defaults: { network: blockchain }, format: false
      get ":blockchain/dex_protocol/:protocol_name/", to: "#{blockchain[:family]}/dex_protocol#statistics",
          constraints: { blockchain: blockchain[:network], protocol_name: %r{[^/]+} }, defaults: { network: blockchain }, format: false

      get ":blockchain/dex/:exchange/:action", to: "#{blockchain[:family]}/dex#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/dex/:exchange", to: "#{blockchain[:family]}/dex#statistics",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tokenpair/:token1/:token2", to: "#{blockchain[:family]}/token_pair#trading_view",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tokenpair/:token1/:token2/trading_view", to: "#{blockchain[:family]}/token_pair#trading_view",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tokenpair/:token1/:token2/last_trades", to: "#{blockchain[:family]}/token_pair#last_trades",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "ethereum2" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/validator/:index/:action", to: "#{blockchain[:family]}/validator#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/validator/:index", to: "#{blockchain[:family]}/validator#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "ethereum_streaming" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/nft_address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/smart_contract/:address/:action", to: "#{blockchain[:family]}/smart_contract#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address", to: "#{blockchain[:family]}/smart_contract#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/token/:address/:action", to: "#{blockchain[:family]}/token#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:address", to: "#{blockchain[:family]}/token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/token/:address/id/:id", to: "#{blockchain[:family]}/token#show_nft_id",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:smart_contract/trading", to: "#{blockchain[:family]}/token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/method/:signature/:action", to: "#{blockchain[:family]}/method#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/method/:signature", to: "#{blockchain[:family]}/method#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/event/:signature/:action", to: "#{blockchain[:family]}/event#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/event/:signature", to: "#{blockchain[:family]}/event#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/dex_protocol/:protocol_name/:action", to: "#{blockchain[:family]}/dex_protocol#:action",
          constraints: { blockchain: blockchain[:network], protocol_name: %r{[^/]+} }, defaults: { network: blockchain }, format: false
      get ":blockchain/dex_protocol/:protocol_name/", to: "#{blockchain[:family]}/dex_protocol#statistics",
          constraints: { blockchain: blockchain[:network], protocol_name: %r{[^/]+} }, defaults: { network: blockchain }, format: false

      get ":blockchain/dex/:exchange/:action", to: "#{blockchain[:family]}/dex#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/dex/:exchange", to: "#{blockchain[:family]}/dex#statistics",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tokenpair/:token1/:token2", to: "#{blockchain[:family]}/token_pair#trading_view",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tokenpair/:token1/:token2/trading_view", to: "#{blockchain[:family]}/token_pair#trading_view",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tokenpair/:token1/:token2/last_trades", to: "#{blockchain[:family]}/token_pair#last_trades",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "tron" }.each do |blockchain|
      # fix for google indexing
      get ":blockchain/address/:address/senders", to: redirect { |params, _req|
        "/#{params[:blockchain]}/trc20token/#{params[:address]}/senders"
      }, constraints: { blockchain: blockchain[:network] }
      get ":blockchain/address/:address/receivers", to: redirect { |params, _req|
        "/#{params[:blockchain]}/trc20token/#{params[:address]}/receivers"
      }, constraints: { blockchain: blockchain[:network] }

      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/smart_contract/:address/graph", to: "#{blockchain[:family]}/smart_contract#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address/:action", to: "#{blockchain[:family]}/smart_contract#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address", to: "#{blockchain[:family]}/smart_contract#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/trc20token/:address/:action", to: "#{blockchain[:family]}/trc20token#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/trc20token/:address", to: "#{blockchain[:family]}/trc20token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/trc10token/:address/:action", to: "#{blockchain[:family]}/trc10token#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/trc10token/:address", to: "#{blockchain[:family]}/trc10token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/method/:signature/:action", to: "#{blockchain[:family]}/method#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/method/:signature", to: "#{blockchain[:family]}/method#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/event/:signature/:action", to: "#{blockchain[:family]}/event#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/event/:signature", to: "#{blockchain[:family]}/event#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/dex_protocol/:protocol_name/:action", to: "#{blockchain[:family]}/dex_protocol#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/dex_protocol/:protocol_name", to: "#{blockchain[:family]}/dex_protocol#statistics",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/dex/:exchange/:action", to: "#{blockchain[:family]}/dex#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/dex/:exchange", to: "#{blockchain[:family]}/dex#statistics",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "eos" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/money_flow", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network], address: %r{[^/]+} }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network], address: %r{[^/]+} }, defaults: { network: blockchain }

      get ":blockchain/smart_contract/:address/money_flow", to: "#{blockchain[:family]}/smart_contract#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address/:action", to: "#{blockchain[:family]}/smart_contract#:action",
          constraints: { blockchain: blockchain[:network], address: %r{[^/]+} }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address", to: "#{blockchain[:family]}/smart_contract#show",
          constraints: { blockchain: blockchain[:network], address: %r{[^/]+} }, defaults: { network: blockchain }

      get ":blockchain/token/:address/money_flow", to: "#{blockchain[:family]}/token#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:address/:action", to: "#{blockchain[:family]}/token#:action",
          constraints: { blockchain: blockchain[:network], address: %r{[^/]+} }, defaults: { network: blockchain }
      get ":blockchain/token/:address", to: "#{blockchain[:family]}/token#show",
          constraints: { blockchain: blockchain[:network], address: %r{[^/]+} }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/method/:signature/:action", to: "#{blockchain[:family]}/method#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/method/:signature", to: "#{blockchain[:family]}/method#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/event/:signature/:action", to: "#{blockchain[:family]}/event#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/event/:signature", to: "#{blockchain[:family]}/event#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "conflux" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/smart_contract/:address/graph", to: "#{blockchain[:family]}/smart_contract#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address/:action", to: "#{blockchain[:family]}/smart_contract#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address", to: "#{blockchain[:family]}/smart_contract#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/token/:address/graph", to: "#{blockchain[:family]}/token#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:address/:action", to: "#{blockchain[:family]}/token#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:address", to: "#{blockchain[:family]}/token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:hash/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:hash", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/method/:signature/:action", to: "#{blockchain[:family]}/method#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/method/:signature", to: "#{blockchain[:family]}/method#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/event/:signature/:action", to: "#{blockchain[:family]}/event#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/event/:signature", to: "#{blockchain[:family]}/event#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "hedera" }.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", to: "#{blockchain[:family]}/network#transactions"

          get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action"

          get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show"
          get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action"

          # route with dot parameter is not available by default.
          get ":blockchain/topics/:topic_id", to: "#{blockchain[:family]}/topics#show",
              constraints: { topic_id: %r{[^/]+} }
          get ":blockchain/topics/:topic_id/:action", to: "#{blockchain[:family]}/topics#:action",
              constraints: { topic_id: %r{[^/]+} }

          get ":blockchain/accounts/:account_id", to: "#{blockchain[:family]}/accounts#show",
              constraints: { account_id: %r{[^/]+} }
          get ":blockchain/accounts/:account_id/:action", to: "#{blockchain[:family]}/accounts#:action",
              constraints: { account_id: %r{[^/]+} }

          get ":blockchain/nodes/:node_account", to: "#{blockchain[:family]}/nodes#show",
              constraints: { node_account: %r{[^/]+} }
          get ":blockchain/payers/:payer_account", to: "#{blockchain[:family]}/payers#show",
              constraints: { payer_account: %r{[^/]+} }

          get ":blockchain/contracts/:contract_id", to: "#{blockchain[:family]}/contracts#show",
              constraints: { contract_id: %r{[^/]+} }

          get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index"
        end
      end
    end

    BLOCKCHAINS.select { |b| b[:family] == "binance" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/order/:order/:action", to: "#{blockchain[:family]}/order#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/order/:order", to: "#{blockchain[:family]}/order#statuses",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/token/:symbol/:action", to: "#{blockchain[:family]}/token#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:symbol", to: "#{blockchain[:family]}/token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "bitcoin" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "cardano" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "filecoin" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/message/:hash", to: "#{blockchain[:family]}/message#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/message/:hash/transfers", to: "#{blockchain[:family]}/message#transfers",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/height/:height/:action", to: "#{blockchain[:family]}/height#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/height/:height", to: "#{blockchain[:family]}/height#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "algorand" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/smart_contract/:address/graph", to: "#{blockchain[:family]}/smart_contract#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address/:action", to: "#{blockchain[:family]}/smart_contract#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/smart_contract/:address", to: "#{blockchain[:family]}/smart_contract#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/token/:id/:action", to: "#{blockchain[:family]}/token#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/token/:id", to: "#{blockchain[:family]}/token#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/txs/:action", to: "#{blockchain[:family]}/tx_list#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "solana" }.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", to: "#{blockchain[:family]}/network#blocks"

          get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action"

          get ":blockchain/block/:block_id", to: "#{blockchain[:family]}/block#show"
          get ":blockchain/block/:block_id/:action", to: "#{blockchain[:family]}/block#:action"

          get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show"
          get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action"

          get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show"
          get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action"

          get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index"
        end
      end
    end

    BLOCKCHAINS.select { |b| b[:family] == "elrond" }.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", to: "#{blockchain[:family]}/network#shards"

          get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action"

          get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show"
          get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action"

          get ":blockchain/call_result/:hash", to: "#{blockchain[:family]}/call_result#show"
          get ":blockchain/call_result/:hash/:action", to: "#{blockchain[:family]}/call_result#:action"

          get ":blockchain/block/:hash", to: "#{blockchain[:family]}/block#show"
          get ":blockchain/block/:hash/:action", to: "#{blockchain[:family]}/block#:action"

          get ":blockchain/miniblocks/:hash", to: "#{blockchain[:family]}/miniblocks#show"
          get ":blockchain/miniblocks/:hash/:action", to: "#{blockchain[:family]}/miniblocks#:action"

          get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show"
          get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action"

          get ":blockchain/validators/:hash", to: "#{blockchain[:family]}/validators#show"
          get ":blockchain/validators/:hash/:action", to: "#{blockchain[:family]}/validators#:action"

          get ":blockchain/shards/:id", to: "#{blockchain[:family]}/shards#show"
          get ":blockchain/shards/:id/:action", to: "#{blockchain[:family]}/shards#:action"

          get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index"
        end
      end
    end

    BLOCKCHAINS.select { |b| b[:family] == "cosmos" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/graph", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/height/:height", to: "#{blockchain[:family]}/height#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    BLOCKCHAINS.select { |b| b[:family] == "flow" }.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", to: "#{blockchain[:family]}/network#blocks"

          get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action"

          get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show"
          get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action"

          get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show"
          get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action"

          get ":blockchain/collections/:hash", to: "#{blockchain[:family]}/collections#show"
          get ":blockchain/collections/:hash/:action", to: "#{blockchain[:family]}/collections#:action"

          get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show"
          get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action"

          get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index"
        end
      end
    end

    BLOCKCHAINS.select { |b| b[:family] == "stellar" }.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", to: "#{blockchain[:family]}/network#blocks"
          get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action"

          get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show"
          get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action"

          get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show"
          get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action"

          get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show"
          get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action"

          get ":blockchain/token/:address", to: "#{blockchain[:family]}/token#show"
          get ":blockchain/token/:address/:action", to: "#{blockchain[:family]}/token#:action"

          get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index"
        end
      end
    end

    BLOCKCHAINS.select { |b| b[:family] == "ripple" }.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", to: "#{blockchain[:family]}/network#blocks"
          get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action"

          get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show"
          get ":blockchain/address/:address/:action", to: "#{blockchain[:family]}/address#:action"

          get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show"
          get ":blockchain/tx/:hash/:action", to: "#{blockchain[:family]}/tx#:action"

          get ":blockchain/block/:block", to: "#{blockchain[:family]}/block#show"
          get ":blockchain/block/:block/:action", to: "#{blockchain[:family]}/block#:action"

          get ":blockchain/token/:address", to: "#{blockchain[:family]}/token#show"
          get ":blockchain/token/:address/:action", to: "#{blockchain[:family]}/token#:action"

          get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index"
        end
      end
    end

    BLOCKCHAINS.select { |b| b[:family] == "tezos" }.each do |blockchain|
      get ":blockchain/:action", to: "#{blockchain[:family]}/network#:action",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain", to: "#{blockchain[:family]}/network#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/address/:address/money_flow", to: "#{blockchain[:family]}/address#money_flow",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address", to: "#{blockchain[:family]}/address#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
      get ":blockchain/address/:address/balances", to: "#{blockchain[:family]}/address#balances",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/tx/:hash", to: "#{blockchain[:family]}/tx#show",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/height/:height", to: "#{blockchain[:family]}/height#blocks",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }

      get ":blockchain/sitemap/index.xml", to: "#{blockchain[:family]}/sitemap#index",
          constraints: { blockchain: blockchain[:network] }, defaults: { network: blockchain }
    end

    match "search(/:query)", to: "search#show", via: %i[get post], as: "search", constraints: { query: %r{[^/]+} }

    post "proxy_graphql", to: "proxy_graphql#index", defaults: { format: :json }
    post "proxy_streaming_graphql", to: "proxy_streaming_graphql#index", defaults: { format: :json }

    get "proxy_dbcode/:dashbord_url", to: "proxy_dbcode#index", defaults: { format: :json }

    get "platform/:action", controller: "home"
    get "graphql(/:param)" => "utility#graphql"
    get "graphql/reset(/:token)" => "utility#graphql"
    root "home#index"

    # error pages
    # %w( 404 422 500 503 400 401 403 ).each do |code|
    ##  match "/#{code}", :to => :error, controller: "utility", id: code, via: :all
    #  match "/#{code}", :to => "utility#errors", via: :all
    # end
    get "sitemap.xml" => "sitemaps#index"
    get "robots.txt" => "sitemaps#robots"
    get "*path" => "utility#errors"
  end
end
