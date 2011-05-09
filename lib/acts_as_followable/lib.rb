module ActsAsFollowable
  module Lib
    
    def self.class_name(obj)
      return obj.class.name
    end

    module InstanceMethods
      def class_name(obj)
        return obj.class.name
      end
    end
    
  end
end

