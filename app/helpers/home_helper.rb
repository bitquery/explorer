module HomeHelper
  def grouped_families
    families = BLOCKCHAINS.group_by { |bc| bc[:platform] }
    groups = []
    group = []
    families.each do |f|
      group << f
      if group.sum { |g| g.second.count } > 4
        groups << group
        group = []
      end
    end
    groups << group unless group.empty?

    groups
  end
end
