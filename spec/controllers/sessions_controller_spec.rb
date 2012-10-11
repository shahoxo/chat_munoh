require 'spec_helper'

describe SessionsController do
  describe "GET create" do
    context "with valid params" do
      let!(:auth) { {"provider" => "twitter", "uid" => "uid00001", "info" => {"name" => "shito"}} }
      before do
        request.env['omniauth.auth'] = auth
        post :create, :provider => auth["provider"]
      end

      it { response.should redirect_to root_url }
    end

    context "with invalid params" do
      let!(:auth) { {"provider" => "twitter", "uid" => nil, "info" => {"name" => "shito"}} }
      before do
        request.env['omniauth.auth'] = auth
        post :create, :provider => auth["provider"]
      end

      it { response.should redirect_to new_session_url }
    end
  end
end
