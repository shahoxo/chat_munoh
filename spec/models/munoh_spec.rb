require 'spec_helper'

describe Munoh do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_many(:rooms) }
  end

  describe "#valid_twitter_name?" do
    context "with valid value" do
      subject { FactoryGirl.build(:munoh) }
      it { should be_valid_twitter_name }
    end

    context "with invalid value" do
      subject { FactoryGirl.build(:munoh, twitter_name: nil) }
      it { should_not be_valid_twitter_name}
    end
  end

  describe "#try_to_get_valid_response" do
    before do
      Twitter::Client.any_instance.stub(:user_timeline).and_return([])
    end

    let!(:munoh) { FactoryGirl.create(:munoh) }
    named_let(:new_twitter_name) { munoh.twitter_name = "still_unsave_twitter_name" }
    named_let(:old_twitter_name) { Munoh.find(munoh).twitter_name }

    context "raise exception" do

      subject { munoh.twitter_name }

      context "too many requests" do
        before do
          munoh.twitter_name = "still_unsave_twitter_name"
          Munoh.any_instance.stub(:retrieve_phrases_on_timeline).and_raise(Twitter::Error::TooManyRequests)
          munoh.try_to_get_valid_response
        end
        it { should eq old_twitter_name }
      end

      context "not found" do
        before do
          munoh.twitter_name = "still_unsave_twitter_name"
          Munoh.any_instance.stub(:retrieve_phrases_on_timeline).and_raise(Twitter::Error::NotFound)
          munoh.try_to_get_valid_response
        end

        it { should eq old_twitter_name }
      end

      context "forbidden" do
        before do
          munoh.twitter_name = "still_unsave_twitter_name"
          Munoh.any_instance.stub(:retrieve_phrases_on_timeline).and_raise(Twitter::Error::Forbidden)
          munoh.try_to_get_valid_response
        end

        it { should eq old_twitter_name }
      end
    end

    context "no exception" do
      before do
        Munoh.any_instance.should_receive(:valid_twitter_name?).and_return(true)
        Munoh.any_instance.should_receive(:retrieve_phrases_on_timeline).and_return(true)
      end

      it "should receive method 'retrieve_phrases_on_timeline'" do
        munoh.try_to_get_valid_response
      end
    end

  end

  describe "#retrieve_phrases_on_timeline" do
    include_context "request_to_twitter_stub"

    let!(:munoh) { FactoryGirl.create(:munoh) }
    let!(:tweet) { {"keyword" => "first tweet", "reply" => "tweet!"} }

    before do
      MyTwitterClient.any_instance.stub(:user_timeline).and_return([tweet])
      munoh.retrieve_phrases_on_timeline
    end

    subject { munoh.phrases }
    it { should have(1).items }
    it "should have keyword 'first tweet' on first object" do
      subject.first.keyword.should eq "first tweet"
    end
    it "should have reply 'tweet!' on first object" do
      subject.first.reply.should eq "tweet!"
    end
  end
end
