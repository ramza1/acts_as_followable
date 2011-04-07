%w( acts_as_followable/version
    acts_as_followable/followable 
    ../app/models/follow
).each do |lib|
    require File.join(File.dirname(__FILE__), lib)  
end
require File.join(Rails.root||RAILS_ROOT, 'app', 'models', 'follow') rescue nil

ActiveRecord::Base.send(:include, ActsAsFollowable::Followable)
