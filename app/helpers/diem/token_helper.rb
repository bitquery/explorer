module Diem::TokenHelper


  def limited_date_range_limit from, till
    if till=='null'
      ["'#{(Date.today-1).to_s}'", 'null']
    else
      ["'#{(Date.parse(till)-1).to_s}'", till]
    end

  end

end
