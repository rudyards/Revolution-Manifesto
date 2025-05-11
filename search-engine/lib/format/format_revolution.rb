class FormatRevolution < Format
  def build_included_sets
    last_rotation = rotation_schedule.map do |rotation_time, rotation_sets|
      rotation_time = Date.parse(rotation_time)
      if !@time or @time >= rotation_time
        [rotation_time, rotation_sets]
      else
        nil
      end
    end.compact.max_by(&:first)
    if last_rotation
      last_rotation.last.to_set
    else
      Set[]
    end
  end

  def format_pretty_name
    "Revolution"
  end

  def rotation_schedule
    {
      # 3 rotations per year, two sets enter in May
      "2021-09-18" => ["trx", "old", "cyb", "cny", "ccr", "err", "kdt"],
    }
  end
end
