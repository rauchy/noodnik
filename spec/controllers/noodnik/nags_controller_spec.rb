require 'spec_helper'

describe NagsController do

  describe "GET 'postpone'" do
    it "should be successful" do
      get 'postpone'
      response.should be_success
    end
  end

  describe "GET 'complete'" do
    it "should be successful" do
      get 'complete'
      response.should be_success
    end
  end

end
