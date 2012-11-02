require 'spec_helper'

describe Munoh do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_many(:rooms) }
  end

  describe "#valid_twitter_name?" do
    context "valid value" do
      subject { FactoryGirl.build(:munoh) }
      it { should be_valid_twitter_name }
    end

    context "invalid value" do
      subject { FactoryGirl.build(:munoh, twitter_name: nil) }
      it { should_not be_valid_twitter_name}
    end
  end

  describe "try_to_get_valid_response" do

  end

  describe "#twitter_client" do

  end

  describe "set_phrases" do

  end

  describe "format_reply" do

  end

  describe "remove_noise" do
    context "with '@username'" do
      subject { FactoryGirl.build(:munoh) }
      it { format_reply("@hogehoge good test!").should eq "method test!"}
    end
  end
end
