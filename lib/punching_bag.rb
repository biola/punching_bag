module PunchingBag
  require 'punching_bag/engine' if defined?(Rails)
  require 'punching_bag/acts_as_punchable'
  require 'punching_bag/railtie'

  def self.punch(punchable, request = nil, count = 1)
    if request.try(:is_crawler?)
      false
    else
      p = Punch.new
      p.punchable = punchable
      p.hits = count
      p.save ? p : false
    end
  end

  def self.average_time(*punches)
    total_time = 0
    hits = 0
    punches.each do |punch|
      total_time += punch.average_time.to_f * punch.hits
      hits += punch.hits
    end
    Time.zone.at(total_time / hits)
  end
end
