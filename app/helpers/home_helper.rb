module HomeHelper


  def grouped_families
    families = BLOCKCHAINS.group_by{|bc| bc[:platform]}
    groups = []
    group = []
    families.each{|f|
      group << f
      if group.map{|g| g.second.count }.sum > 4
        groups << group
        group = []
      end
    }
    groups << group unless group.empty?

    groups
  end

end
