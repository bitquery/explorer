module Bitcoin::NetworkHelper

  def limited_date_range_limit_days from, till, days
    if till=='null'
      if days
        ["'#{(Date.today-days).to_s}'", 'null']
      else
        ["'#{(Date.today-1).to_s}'", 'null']
      end
    else
      ["'#{(Date.parse(till)-1).to_s}'", till]
    end

  end

end
