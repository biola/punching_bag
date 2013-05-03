module PunchingBag
  module ActiveRecord
  
    module ClassMethods

      # Note: this method will only return items if they have 1 or more hits
      def most_hit(since=nil, limit=5)
        query = self.scoped.joins(:punches).group(:punchable_type, :punchable_id, "#{table_name}.#{self.class.primary_key}")
        query = query.where('punches.average_time >= ?', since) unless since.nil?
        query.reorder('SUM(punches.hits) DESC').limit(limit)
      end

      # Note: this method will return all items with 0 or more hits
      def sort_by_popularity(dir='DESC')
        query = self.scoped.joins("LEFT OUTER JOIN punches ON punches.punchable_id = #{table_name}.id AND punches.punchable_type = '#{self.name}'")
        query = query.group(:id)
        query.reorder("SUM(punches.hits) #{dir}")
      end
    end
    
    module InstanceMethods
      def hits(since=nil)
        self.punches.after(since).sum(:hits)
      end
      
      def punch(request=nil)
        PunchingBag.punch(self, request)
      end
    end
    
  end
end

class ActiveRecord::Base
  def self.acts_as_punchable
    extend PunchingBag::ActiveRecord::ClassMethods
    include PunchingBag::ActiveRecord::InstanceMethods
    has_many :punches, :as => :punchable, :dependent => :destroy
  end
end
