require File.dirname(__FILE__) + '/test_helper'

class ActsAsFollowableTest < ActiveSupport::TestCase

  context "instance methods" do
    setup do
      @sam = Factory(:sam)
    end

    should "be defined" do
      assert @sam.respond_to?(:followings)
      assert @sam.respond_to?(:follows)
      assert @sam.respond_to?(:followed_by?)
    end
  end

  context "acts_as_followable" do
    setup do
      @sam = Factory(:sam)
      @jon = Factory(:jon)
      @oasis = Factory(:oasis)
      @metallica = Factory(:metallica)
      @sam.follow(@jon)
    end

    context "followers_count" do
      should "return the number of followers" do
        assert_equal 0, @sam.followings.count
        assert_equal 1, @jon.followings.count
      end

      should "return the proper number of multiple followers" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        assert_equal 0, @sam.followings.count
        assert_equal 1, @jon.followings.count
        assert_equal 1, @bob.followings.count
      end
    end

    context "followers" do
      should "return users" do
        assert_equal [], User.following(@sam)
        assert_equal [@sam], User.following(@jon)
      end

      should "return users (multiple followers)" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        assert_equal [], @sam.followings
        assert_equal [@sam], User.following(@jon)
        assert_equal [@sam], User.following(@bob)
      end

      should "return users (multiple followers, complex)" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        @jon.follow(@bob)
        assert_equal [], User.following(@sam)
        assert_equal [@sam], User.following(@jon)
        assert_equal [@sam, @jon], User.following(@bob)
      end
    end

    context "followed_by" do
      should "return_follower_status" do
        assert_equal true, @jon.followed_by?(@sam)
        assert_equal false, @sam.followed_by?(@jon)
      end
    end

    context "destroying a followable" do
      should "also destroy the Follow" do
        assert_equal 1, Follow.count
        assert_equal 1, @sam.follows.count
        @jon.destroy
        assert_equal 0, Follow.count
        assert_equal 0, @sam.follows.count
      end
    end

    context "followers_by_type" do
      setup do
        @sam.follow(@oasis)
        @jon.follow(@oasis)
      end

      should "return the followers for given type" do
        assert_equal [@sam], @jon.followers_by_type('User')
        assert_equal [@sam,@jon], @oasis.followers_by_type('User')
      end

      should "return the count for followers_by_type_count for a given type" do
        assert_equal 1, @jon.followers_by_type('User').count
        assert_equal 2, @oasis.followers_by_type('User').count
      end
    end

    context "method_missing" do
      setup do
        @sam.follow(@oasis)
        @jon.follow(@oasis)
      end

      should "return the followers for given type" do
        assert_equal [@sam], @jon.user_followers
        assert_equal [@sam,@jon], @oasis.user_followers
      end

      should "return the count for followers_by_type_count for a given type" do
        assert_equal 1, @jon.user_followers.count
        assert_equal 2, @oasis.user_followers.count
      end
    end
  end

end
