require 'spec_helper'

describe User do

  describe "association" do
    it { should have_many(:rooms) }
  end

  describe ".create_with_omniauth" do
    context "correct params" do
      let!(:auth) { {"provider" => "twitter", "uid" => "uid00001", "info" => {"name" => "shito"}} }
      it { expect{ User.create_with_omniauth(auth)}.to change{ User.count }.by(1) }
    end

    context "incorrect params" do
      let!(:auth) { {"provider" => nil, "uid" => "uid00001", "info" => {"name" => "shito"}} }
      it { expect{ User.create_with_omniauth(auth)}.to_not change{ User.count } }
    end
  end
end
