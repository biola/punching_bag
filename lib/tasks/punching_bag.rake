namespace :punching_bag do

  desc 'Combine old hit records together to improve performance'
  task :combine, [:by_day_after, :by_month_after, :by_year_after] => [:environment] do |t, args|
    args.with_defaults :by_day_after => 7, :by_month_after => 1, :by_year_after => 1 
    
    punchables = Punch.all.map(&:punchable).uniq
    punchables.each do |punchable|
      
      # by_year
      punchable.punches.before(args[:by_year_after].years.ago).each do |punch|
        punch.combine_by_year
      end
      
      # by_month
      punchable.punches.before(args[:by_month_after].months.ago).each do |punch|
        punch.combine_by_month
      end
      
      # by_day
      punchable.punches.before(args[:by_day_after].days.ago).each do |punch|
        punch.combine_by_day
      end
      
    end
    
  end

end
