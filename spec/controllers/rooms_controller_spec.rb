require 'spec_helper'

describe RoomsController do
  before do
    controller.stub(:login_required) { true }
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
