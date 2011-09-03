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

      it "yields the block in a div with class 'noodnik-nag'" do
        helper.nag_user_to :register do |nag|
          "I should be in a <div>!"
        end.should match(%r[<div class="noodnik-nag">.*</div>])
      end

      it "should yield the block for a new topic" do
        helper.nag_user_to :register do |nag|
          "Register!"
        end.should include("Register!")
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
        end.should include("Register!")
      end
    end
  end

  describe "link_to" do
    it "adds 'data-noodnik-topic' with the correct topic when no html_options provided" do
      link = nag_user_to :register do
        link_to 'google.com', 'www.google.com'
      end.should include('data-noodnik-topic="register"')
    end

    it "adds 'data-noodnik-topic' with the correct topic to existing html_options" do
      link = nag_user_to :register do
        link_to 'google.com', 'www.google.com', class: 'foo'
      end.should include('data-noodnik-topic="register"')
    end
  end

  describe "postpone_for" do
    before :each do
      @link = nag_user_to :register do
        postpone_for 14.days
      end
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

    it "does not mark postpone links with 'data_noodnik_topic'" do
      @link.should_not include("data-noodnik-topic")
    end
  end
end
