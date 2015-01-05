class Punch < ActiveRecord::Base

  belongs_to :punchable, :polymorphic => true

  before_validation :set_defaults
  validates :punchable_id, :punchable_type, :starts_at, :ends_at, :average_time, :hits, :presence => true

  default_scope -> { order 'punches.average_time DESC' }
  scope :combos, -> { where 'punches.hits > 1' }
  scope :jabs, -> { where hits: 1 }
  scope :before, ->(time = nil) { where('punches.ends_at <= ?', time) unless time.nil? }
  scope :after, ->(time = nil) { where('punches.average_time >= ?', time) unless time.nil? }
  scope :by_timeframe, ->(timeframe, time) {
    where('punches.starts_at >= ? AND punches.ends_at <= ?', time.send("beginning_of_#{timeframe}"), time.send("end_of_#{timeframe}"))
  }
  scope :by_hour, ->(hour) { by_timeframe :hour, hour }
  scope :by_day, ->(day) { by_timeframe :day, day }
  scope :by_month, ->(month) { by_timeframe :month, month }
  scope :by_year, ->(year) {
    year = DateTime.new(year) if year.is_a? Integer
    by_timeframe :year, year
  }
  scope :except_for, ->(punch) { where('id != ?', punch.id) }

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
    elsif starts_at.hour != ends_at.hour
      :day
    elsif starts_at != ends_at
      :hour
    else
      :second
    end
  end

  def hour_combo?
    timeframe == :hour and not find_true_combo_for(:hour) == self
  end

  def day_combo?
    timeframe == :day and not find_true_combo_for(:day) == self
  end

  def month_combo?
    timeframe == :month and not find_true_combo_for(:month) == self
  end

  def year_combo?
    timeframe == :year and not find_true_combo_for(:year) == self
  end

  def find_combo_for(timeframe)
    punches = punchable.punches.by_timeframe(timeframe, average_time).except_for(self)
    punches.combos.first || punches.first
  end

  def find_true_combo_for(timeframe)
    punchable.punches.combos.by_timeframe(timeframe, average_time).first
  end

  def combine_with(combo)
    if combo && combo != self
      combo.starts_at = starts_at if starts_at < combo.starts_at
      combo.ends_at = ends_at if ends_at > combo.ends_at
      combo.average_time = PunchingBag.average_time(combo, self)
      combo.hits += hits
      self.destroy if combo.save
    end
    combo
  end

  def combine_by_hour
    unless hour_combo? || day_combo? || month_combo? || year_combo?
      combine_with find_combo_for(:hour)
    end
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

  def self.average_for(punchables)
    if punchables.map(&:class).uniq.length > 1
      raise ArgumentError, 'Punchables must all be of the same class'
    end

    sums = Punch.where(punchable_type: punchables.first.class.to_s, punchable_id: punchables.map(&:id)).group(:punchable_id).sum(:hits)

    return 0 if sums.empty? # catch divide by zero

    sums.values.inject(:+).to_f / sums.length
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
