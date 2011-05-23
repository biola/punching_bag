class Punch < ActiveRecord::Base

  belongs_to :punchable, :polymorphic => true

  attr_accessible # none

  before_validation :set_defaults
  validates :punchable_id, :punchable_type, :starts_at, :ends_at, :average_time, :hits, :presence => true

  default_scope order('punches.average_time DESC')
  scope :combos, where('punches.hits > 1')
  scope :jabs, where(:hits => 1)
  scope :before, lambda{ |time| where('punches.ends_at <= ?', time) }
  scope :after, lambda{ |*args|
    time = args.first
    time.nil?? scoped : where('punches.average_time >= ?', time)
  }
  scope :by_timeframe, lambda{ |timeframe, time|
    where('punches.starts_at >= ? AND punches.ends_at <= ?', time.send("beginning_of_#{timeframe}"), time.send("end_of_#{timeframe}"))
  }
  scope :by_day, lambda { |day| by_timeframe(:day, day) }
  scope :by_month, lambda { |month| by_timeframe(:month, month) }
  scope :by_year, lambda { |year|
    year = DateTime.new(year) if year.is_a? Integer
    by_timeframe(:year, year)
  }

  def jab?
    hits == 1
  end

  def combo?
    hits > 1
  end

  def timeframe
    if starts_at.month != ends_at.month
      :year
    elsif starts_at.day != ends_at.day
      :month
    elsif starts_at != ends_at
      :day
    else
      :second
    end
  end

  def day_combo?
    timeframe == :day
  end
  
  def month_combo?
    timeframe == :month
  end
  
  def year_combo?
    timeframe == :year
  end
  
  def find_combo_for(timeframe)
    punches = punchable.punches.by_timeframe(timeframe, average_time)
    punches.combos.first || punches.first
  end
  
  def combine_with(combo)
    if combo != self
      combo.starts_at = starts_at if starts_at < combo.starts_at
      combo.ends_at = ends_at if ends_at > combo.ends_at
      combo.average_time = PunchingBag.average_time(combo, self)
      combo.hits += hits
      self.destroy if combo.save
    end
    combo
  end
  
  def combine_by_day
    unless day_combo? || month_combo? || year_combo?
      combine_with find_combo_for(:day)
    end
  end
  
  def combine_by_month
    unless month_combo? || year_combo?
      combine_with find_combo_for(:month)
    end
  end
  
  def combine_by_year
    unless year_combo?
      combine_with find_combo_for(:year)
    end
  end

  private
  
  def set_defaults
    if date = (self.starts_at ||= DateTime.now)
      self.ends_at ||= date
      self.average_time ||= date
      self.hits ||= 1
    end
  end

end
