class Ethereum::DexProtocolController < NetworkController
  before_action :set_protocol, :breadcrumb
  helper_method :api_version_for_protocol

  layout 'tabs'

  def statistics
    render 'ethereum/dex_protocol/statistics_v2' if @streaming
  end

  private
  def set_protocol
    @protocol = params[:protocol_name]
    # hardcode fix, used to pass this arg to the query
    @protocol = 'seaport_v1.4' if @protocol == 'seaport_v1'
  end

  def breadcrumb
    @breadcrumbs << {name: @protocol} << {name: t("tabs.#{controller_name}.#{action_name}.name")}
  end

  def api_version_for_protocol
    decoded_protocol_name = CGI.unescape(@protocol)
    v2_protocols = [
        'airswap_v2',
        'balancer_v1',
        'balancer_v2',
        'bancor_v2',
        'blur_v1',
        'cofix_v1',
        'curve_v1',
        'curve_v2',
        'ddex_hydro_v1_0',
        'ddex_hydro_v1_1',
        'dexblue_v1',
        'dodo_v1',
        'dydx_v2',
        'ether_delta_v1',
        'fegex_v1',
        'foundation',
        'idex_v1',
        'idex_v2',
        'kyber_network_v1',
        'kyber_network_v2',
        'kyber_network_v3',
        'kyber_network_v4',
        'looks_rare_v2',
        'mooniswap_v1',
        'oasis_v1',
        'opensea_v2',
        'pancake_swap_v3',
        'seaport_v1.4',
        'smart_defi_v1',
        'token_store_v1',
        'uniswap_v1',
        'uniswap_v2',
        'uniswap_v3',
        'x2y2',
        'zerox_v1',
        'zerox_v2',
        'zerox_v3',
        'zerox_v4'
    ]
    v1_protocols = [
        'IDEX v2',
        'Curve',
        'Bancor Network v2',
        'Kyber Network v4',
        'Cofix',
        'EtherDelta',
        'DDEX Hydro v1.0',
        'DDEX Hydro v1.1',
        'Kyber Network',
        'Mooniswap',
        'AirSwap v2',
        'FEGex v0',
        'Matching Market',
        'Zerox Exchange v4',
        'Token.Store',
        'ETHERCExchange',
        'Uniswap v2',
        'Uniswap v3',
        'Smart DeFi',
        'dYdX2',
        'FEGex',
        'Bancor Network',
        'Zerox Exchange v3',
        'Zerox Exchange v2',
        'DUBIex',
        'AXNET',
        'AirSwap Exchange',
        'Kyber Network v3',
        'Kyber Network v2',
        'IDEX',
        'Dodo',
        'One Inch Liquidity Pool',
        'Balancer Pool Token',
        'Ethfinex'
    ]

    if v2_protocols.include?(decoded_protocol_name)
      'v2'
    elsif v1_protocols.include?(decoded_protocol_name)
      'v1'
    else
      nil
    end
  end
end
