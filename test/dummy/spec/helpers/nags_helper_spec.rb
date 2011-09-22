require 'spec_helper'

describe Noodnik::NagsHelper do

  describe "nag_user_to" do
    before :each do
      @topic = :register
    end

    describe "when signed in" do
      before :each do
        @user_id = 1
        set_current_user_id(@user_id)
      end

      after :each do
        Noodnik::Nag.delete_all
      end

      it "yields the block in a div with class 'noodnik-nag'" do
        helper.nag_user_to :register do |nag|
          "I should be in a <div>!"
        end.should match(%r[<div class="noodnik-nag">.*</div>])
      end

      it "yields the block for a new topic" do
        helper.nag_user_to :register do |nag|
          "Register!"
        end.should include("Register!")
      end

      it "does not yield the block if topic has been postponed" do
        Noodnik::Nag.create! user_id: @user_id, topic: @topic, next_nag: 2.weeks.from_now

        helper.nag_user_to :register do |nag|
          "I should not be returned!"
        end.should be_nil
      end

      it "yields the block if postpone expired" do
        Noodnik::Nag.create! user_id: @user_id, topic: @topic, next_nag: 1.week.ago

        helper.nag_user_to :register do |nag|
          "Register!"
        end.should include("Register!")
      end

      it "does not yield the block if topic was completed" do
        Noodnik::Nag.create! user_id: @user_id, topic: @topic, next_nag: 10.weeks.ago, completed: true

        helper.nag_user_to :register do |nag|
          "I should not be returned!"
        end.should be_nil
      end
    end

    describe "when not signed in" do
      before :each do
        set_current_user_id(nil)
        @cookies = mock('cookies')
        helper.stub!(:cookies).and_return(@cookies)
      end

      it "yields the block in a div with class 'noodnik-nag'" do
        @cookies.should_receive(:[]).with(:register).and_return(nil)
        helper.nag_user_to :register do |nag|
          "I should be in a <div>!"
        end.should match(%r[<div class="noodnik-nag">.*</div>])
      end

      it "yields the block for a new topic" do
        @cookies.should_receive(:[]).with(:register).and_return(nil)
        helper.nag_user_to :register do |nag|
          "Register!"
        end.should include("Register!")
      end

      it "does not yield the block if topic has been postponed" do
        @cookies.should_receive(:[]).with(:register).and_return(2.weeks.from_now.to_s)
        helper.nag_user_to :register do |nag|
          "I should not be returned!"
        end.should be_nil
      end

      it "yields the block if postpone expired" do
        @cookies.should_receive(:[]).with(:register).and_return(2.weeks.ago.to_s)

        helper.nag_user_to :register do |nag|
          "Register!"
        end.should include("Register!")
      end

      it "does not yield the block if topic was completed" do
        @cookies.should_receive(:[]).with(:register).and_return('complete')

        helper.nag_user_to :register do |nag|
          "I should not be returned!"
        end.should be_nil
      end
    end

  end

  describe "link_to" do
    describe "with html_options provided" do
      before :each do
        @link = nag_user_to :register do
          link_to 'google.com', 'www.google.com', class: 'foo'
        end     
      end

      it "adds 'data-noodnik-complete-path' with the correct topic" do
        @link.should include('data-noodnik-complete-path="/noodnik/complete?topic=register"')
      end

      it "adds class 'noodnik-complete'" do
        @link.should include("class=\"foo noodnik-complete\"")
      end
    end

    describe "with no html_options provided" do
      before :each do
        @link = nag_user_to :register do
          link_to 'google.com', 'www.google.com'
        end      
      end

      it "adds 'data-noodnik-complete-path' with the correct topic" do
        @link.should include('data-noodnik-complete-path="/noodnik/complete?topic=register"')
      end

      it "adds class 'noodnik-complete'" do
        @link.should include("class=\"noodnik-complete\"")
      end
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

    it "has class 'noodnik-postpone'" do
      @link.should include("noodnik-postpone")
    end

    # postpone_for is the only type of link inside a nag_user_to block that *should'nt* get class 'noodnik-complete'
    it "does not add class 'noodnik-complete'" do
      @link.should_not include("noodnik-complete")
    end

    it "does not mark postpone links with 'data_noodnik_complete-path'" do
      @link.should_not include("data-noodnik-complete-path=\"/noodnik/complete/register\"")
    end
  end
end
