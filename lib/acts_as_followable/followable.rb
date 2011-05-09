module ActsAsFollowable
  module Followable

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_followable
        include ActsAsFollowable::Lib::InstanceMethods
        include ActsAsFollowable::Followable::InstanceMethods
        
        scope :following, lambda{|followable| includes(:follows).where(['follows.followable_id=? AND follows.followable_type=?', followable.id, ActsAsFollowable::Lib.class_name(followable)]) }
        scope :followed_by, lambda{|follower| includes(:followings).where(['follows.follower_id=? AND follows.follower_type=?', follower.id, ActsAsFollowable::Lib.class_name(follower)]) }
        
        has_many :followings, :as => :followable, :dependent => :destroy, :class_name => 'Follow'
        has_many :follows, :as => :follower, :dependent => :destroy
      end
    end

    module InstanceMethods
      
      # Returns the followers by a given type
      def followers_by_type(type)
        type.constantize.following(self)
      end

      # Returns the actual records of a particular type which this record is following.
      def following_by_type(type)
        type.constantize.followed_by(self)
      end

      # Allows magic names on followers_by_type
      # e.g. followers_by_type('User') > user_followers
      # e.g. following_by_type('User') > following_user
      def method_missing(m, *args)
        if m.to_s[/(.+)_followers/]
          followers_by_type($1.singularize.classify)
        elsif m.to_s[/following_(.+)/]
          following_by_type($1.singularize.classify)
        else
          super
        end
      end

      # Creates a new follow record for this instance to follow the passed object.
      # Does not allow duplicate records to be created.
      def follow(followable)
        follow = follow_for_follawable(followable).first
        if follow.blank?
          Follow.create(:followable_id => followable.id, :followable_type => class_name(followable), :follower_id => self.id, :follower_type => class_name(self))
        end
      end

      # Returns true if this instance is following the object passed as an argument.
      def following?(followable)
        0 < follow_for_follawable(followable).limit(1).count
      end

      # Deletes the follow record if it exists.
      def stop_following(followable)
        if follow = follow_for_follawable(followable).first
          follow.destroy
        end
      end

      # Destroys all followers of a given type
      def destroy_followers_by_type(type)
        Follow.where(['follows.followable_id=? AND follows.followable_type=? AND follows.follower_type=?', self.id, class_name(self), type]).destroy_all
      end

      # Destroys all followings of a given type
      def destroy_followings_by_type(type)
        Follow.where(['follows.follower_id=? AND follows.follower_type=? AND follows.followable_type=?', self.id, class_name(self), type]).destroy_all
      end

      # Returns true if the current instance is followed by the passed record
      def followed_by?(follower)
        0 < follow_for_follower(follower).limit(1).count
      end
      
      private
      
      def follow_for_follawable(followable)
        Follow.where(["follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?", self.id, class_name(self), followable.id, class_name(followable)])
      end
      
      def follow_for_follower(follower)
        Follow.where(["follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?", follower.id, class_name(follower), self.id, class_name(self)])
      end
      
    end

  end
end
