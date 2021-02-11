module Ethereum::TokenHelper
  def limited_date_range_limit(_from, till, days)
    if till == 'null'
      if days
        ["'#{Date.today - days}'", 'null']
      else
        ["'#{Date.today - 1}'", 'null']
      end
    else
      ["'#{Date.parse(till) - 1}'", till]
    end
  end
end
