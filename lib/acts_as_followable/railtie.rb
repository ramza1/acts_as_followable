require 'rails'

module ActsAsFollowable
  if defined? Rails::Railtie
    class Railtie < Rails::Railtie
      initializer "acts_as_followable.extend_action_controller_base" do |app|
        ActiveSupport.on_load(:active_record) do
          ActsAsFollowable::Railtie.insert
        end
      end
    end
  end

  class Railtie
    def self.insert
      require File.join(File.dirname(__FILE__), '..', '..', 'app', 'models', 'follow')
      begin
        require File.join(Rails.root||RAILS_ROOT, 'app', 'models', 'follow')
      rescue LoadError
      end
      ActiveRecord::Base.send(:include, ActsAsFollowable::Followable)
    end
  end
end