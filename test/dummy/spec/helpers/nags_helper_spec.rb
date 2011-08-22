require 'spec_helper'

describe Noodnik::NagsHelper do

  describe "nag_user_to" do
    before :each do
      @topic = :register
    end

    describe "when signed in" do
      before :each do
        @user_id = 1
        Noodnik.setup do |config|
          config.current_user_id = lambda { @user_id }
        end
      end

      after :each do
        Noodnik::Nag.delete_all
      end

      it "should yield the block for a new topic" do
        helper.nag_user_to :register do |nag|
          "Register!"
        end.should eq("Register!")
      end

      it "should not yield the block if postponed" do
        Noodnik::Nag.create! user_id: @user_id, topic: @topic, next_nag: 2.weeks.from_now

        helper.nag_user_to :register do |nag|
          "I should not be returned!"
        end.should be_nil
      end

      it "should yield the block if postpone expired" do
        Noodnik::Nag.create! user_id: @user_id, topic: @topic, next_nag: 1.week.ago

        helper.nag_user_to :register do |nag|
          "Register!"
        end.should eq("Register!")
      end
    end
  end

  describe "postpone_for" do
    # TODO - move this to a spec for testing Context
	  include Rails.application.routes.mounted_helpers  

    before :each do
      nag_context = Context.new(:register, helper, noodnik.routes.url_helpers)
      @link = nag_context.postpone_for 14.days
    end
    
    it "prompts a default message of 'Remind me in 14 days'" do
      @link.should include('Remind me in 14 days')
    end

    it "links to /noodnik/postpone" do
      @link.should include('/noodnik/postpone')
    end

    it "specifies the correct period in the link" do
      @link.should include("period=#{14.days}")
    end

    it "specifies the correct topic" do
      @link.should include("topic=register")
    end

    it "should have class 'postpone-link'" do
      @link.should include("postpone-link")
    end
  end
end
