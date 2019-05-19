module PunchingBag
  module ActiveRecord
    module ClassMethods
      DIRECTIONS = {
        asc: 'ASC',
        desc: 'DESC'
      }.freeze
      DEFAULT_DIRECTION = :desc

      # Note: this method will only return items if they have 1 or more hits
      def most_hit(since = nil, limit = 5)
        query = joins(:punches).group(Punch.arel_table[:punchable_type], Punch.arel_table[:punchable_id], arel_table[primary_key])
        query = query.where('punches.average_time >= ?', since) unless since.nil?
        query.reorder(Arel.sql('SUM(punches.hits) DESC')).limit(limit)
      end

      # Note: this method will return all items with 0 or more hits
      # direction: Symbol (:asc, or :desc)
      def sort_by_popularity(direction = DEFAULT_DIRECTION)
        dir = DIRECTIONS.fetch(
          direction.to_s.downcase.to_sym,
          DIRECTIONS[DEFAULT_DIRECTION]
        )

        query = joins(
          arel_table.join(
            Punch.arel_table, Arel::Nodes::OuterJoin
          ).on(
            Punch.arel_table[:punchable_id].eq(
              arel_table[primary_key]
            ).and(
              Punch.arel_table[:punchable_type].eq(name)
            )
          ).join_sources.first
        )

        query = query.group(arel_table[primary_key])
        query.reorder(Arel.sql("SUM(punches.hits) #{dir}"))
      end
    end

    module InstanceMethods
      def hits(since = nil)
        punches.after(since).sum(:hits)
      end

      def punch(request = nil, options = {})
        count = options[:count] || 1
        PunchingBag.punch(self, request, count)
      end
    end
  end
end

class ActiveRecord::Base
  def self.acts_as_punchable
    extend PunchingBag::ActiveRecord::ClassMethods
    include PunchingBag::ActiveRecord::InstanceMethods
    has_many :punches, as: :punchable, dependent: :destroy
  end
end
