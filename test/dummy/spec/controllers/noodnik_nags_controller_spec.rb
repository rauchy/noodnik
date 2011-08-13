require 'spec_helper'

describe Noodnik::NagsController do
  before :each do 
    @attr = {use_route: :noodnik}
    Noodnik.setup do |config|
      config.current_user_id = lambda { nil }
    end
  end

  describe "when signed in" do
    before :each do
      @user_id = 1
      Noodnik.setup do |config|
        config.current_user_id = lambda { @user_id }
      end
    end

    describe "GET 'postpone'" do
      before :each do
        @topic = :complete_your_registration
        @attr.merge! period: 2.weeks, topic: @topic
      end

      describe "for the first time" do
        it "should create a nag" do
          lambda do
            get :postpone, @attr
          end.should change(Noodnik::Nag, :count).by(1)
        end

        it "should associate it with the correct user id" do
          get :postpone, @attr
          Noodnik::Nag.last.user_id.should == @user_id
        end

        it "should set the provided topic" do
          get :postpone, @attr
          Noodnik::Nag.last.topic.should == @topic.to_s
        end

        it "should set the next nag time correctly" do
          t = Time.parse("01/01/2010 10:00")
          Time.stub!(:now).and_return(t)

          get :postpone, @attr
          Noodnik::Nag.last.next_nag.should == 2.weeks.from_now
        end
      end
    end
  end
end
