namespace :punching_bag do
  desc 'Combine old hit records together to improve performance'
  task(
    :combine,
    %i[by_hour_after by_day_after by_month_after by_year_after] => [:environment]
  ) do |_t, args|
    args.with_defaults(
      by_hour_after: 24,
      by_day_after: 7,
      by_month_after: 1,
      by_year_after: 1
    )

    distinct_method = Rails.version >= '5.0' ? :distinct : :uniq

    punchable_types = Punch.unscope(:order).public_send(
      distinct_method
    ).pluck(:punchable_type)

    punchable_types.each do |punchable_type|
      punchables = punchable_type.constantize.unscoped.find(
        Punch.unscope(:order).public_send(distinct_method).where(
          punchable_type: punchable_type
        ).pluck(:punchable_id)
      )

      punchables.each do |punchable|
        # by_year
        punchable.punches.before(
          args[:by_year_after].to_i.years.ago
        ).each do |punch|
          # Dont use the cached version.
          # We might have changed if we were the combo
          punch.reload
          punch.combine_by_year
        end

        # by_month
        punchable.punches.before(
          args[:by_month_after].to_i.months.ago
        ).each do |punch|
          # Dont use the cached version.
          # We might have changed if we were the combo
          punch.reload
          punch.combine_by_month
        end

        # by_day
        punchable.punches.before(
          args[:by_day_after].to_i.days.ago
        ).each do |punch|
          # Dont use the cached version.
          # We might have changed if we were the combo
          punch.reload
          punch.combine_by_day
        end

        # by_hour
        punchable.punches.before(
          args[:by_hour_after].to_i.hours.ago
        ).each do |punch|
          # Dont use the cached version.
          # We might have changed if we were the combo
          punch.reload
          punch.combine_by_hour
        end
      end
    end
  end
end
