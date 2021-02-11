module Diem::TokenHelper
  def limited_date_range_limit(_from, till)
    if till == 'null'
      ["'#{Date.today - 1}'", 'null']
    else
      ["'#{Date.parse(till) - 1}'", till]
    end
  end
end
