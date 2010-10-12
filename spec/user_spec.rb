require 'spec_helper'

describe User do
  describe ".find_or_create" do
    it "should return new instance for unknown email address" do
      User.find_or_create(next_email).must_be_kind_of User
    end

    it "should return cached instance for known email address" do
      email = next_email
      u = User.find_or_create(email)
      User.find_or_create(email).must_be_same_as u
    end
  end

  describe "instances" do
    before do
      @user = User.find_or_create(next_email)
    end

    it "should know if this is the user's first visit" do
      @user.noob?.must_equal true
    end

    it "should have #game= accessor" do
      game = "foo"
      @user.game = game
      @user.game.must_be_same_as game
    end
  end
end
