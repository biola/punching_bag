module PunchingBag
  module ActiveRecord
  
    module ClassMethods
      def most_hit(since=nil, limit=5)
        query = self.scoped.joins(:punches).group(:punchable_type, :punchable_id)
        query = query.where('punches.average_time >= ?', since) unless since.nil?
        query.order('SUM(punches.hits) DESC').limit(limit)
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
    has_many :punches, :as => :punchable
  end
end
