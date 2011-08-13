require 'spec_helper'

describe Noodnik::NagsController do
  before :each do 
    @topic = :complete_your_registration
    @attr = {use_route: :noodnik, topic: @topic}

    Noodnik.setup do |config|
      config.current_user_id = lambda { nil }
    end
  end

  describe "when not signed in" do
    before :each do
      set_current_user_id(nil)
    end

    describe "GET 'postpone'" do
      before :each do
        @attr.merge! period: 2.weeks
      end

      after :each do
        cookies.clear
      end

      describe "for the first time" do
        before :each do
          stub_time
          get :postpone, @attr
        end

        it "creates a cookie" do
          cookies.count.should == 1
        end

        it "sets the provided topic as the cookie name" do
          cookies.should be_include(@topic)
        end

        it "sets the next nag time correctly" do
          cookies[@topic].should == 2.weeks.from_now.to_s
        end
      end
    end
  end

  describe "when signed in" do
    before :each do
      @user_id = 1
      set_current_user_id(@user_id)
    end

    describe "GET 'postpone'" do
      before :each do
        @attr.merge! period: 2.weeks
      end

      after :each do
        Noodnik::Nag.delete_all
      end

      describe "for the first time" do
        it "creates a nag instance" do
          lambda do
            get :postpone, @attr
          end.should change(Noodnik::Nag, :count).by(1)
        end

        it "sets the correct user id" do
          get :postpone, @attr
          Noodnik::Nag.last.user_id.should == @user_id
        end

        it "sets the provided topic" do
          get :postpone, @attr
          Noodnik::Nag.last.topic.should == @topic.to_s
        end

        it "sets the next nag time correctly" do
          stub_time
          get :postpone, @attr
          Noodnik::Nag.last.next_nag.should == 2.weeks.from_now
        end
      end

      describe "not for the first time" do
        it "modifies the next nag time correctly" do
          nag = Noodnik::Nag.create! user_id: 1, topic: @topic

          stub_time
          get :postpone, @attr
          nag.reload.next_nag.should == 2.weeks.from_now
        end
      end
    end

    describe "GET 'complete'" do
      it "marks the nag as complete" do
        nag = Noodnik::Nag.create! user_id: 1, topic: @topic
        get :complete, @attr
        nag.reload.completed.should be_true
      end
    end
  end

  def set_current_user_id(user_id)
    Noodnik.setup do |config|
      config.current_user_id = lambda { user_id }
    end
  end

  def stub_time
    t = Time.parse("01/01/2010 10:00")
    Time.stub!(:now).and_return(t)
  end
end
