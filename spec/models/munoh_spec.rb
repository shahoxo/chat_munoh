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

    context "with too many requests exception" do
      before do
        munoh.twitter_name = "still_unsave_twitter_name"
        Munoh.any_instance.stub(:set_phrases).and_raise(Twitter::Error::TooManyRequests)
        munoh.try_to_get_valid_response
      end

      it { munoh.twitter_name.should eq Munoh.find(munoh).twitter_name }
    end

    context "with not found exception" do
      before do
        munoh.twitter_name = "still_unsave_twitter_name"
        Munoh.any_instance.stub(:set_phrases).and_raise(Twitter::Error::NotFound)
        munoh.try_to_get_valid_response
      end

      it { munoh.twitter_name.should eq Munoh.find(munoh).twitter_name }
    end

    context "with forbidden exception" do
      before do
        munoh.twitter_name = "still_unsave_twitter_name"
        Munoh.any_instance.stub(:set_phrases).and_raise(Twitter::Error::Forbidden)
        munoh.try_to_get_valid_response
      end

      it { munoh.twitter_name.should eq Munoh.find(munoh).twitter_name }
    end

    context "without exception" do
      before do
        Munoh.any_instance.should_receive(:set_phrases)
      end

      it {munoh.try_to_get_valid_response}
    end

  end

  describe "#twitter_client" do
    include_context "request_to_twitter_stub"

    let(:munoh) { FactoryGirl.create(:munoh) }

    subject { munoh.twitter_client }
    it { should be_kind_of(Twitter::Client) }
  end

  describe "#set_phrases" do
    include_context "request_to_twitter_stub"

    let!(:munoh) { FactoryGirl.create(:munoh) }
    let!(:tweet) { Twitter::Tweet.new(id: 1, in_reply_to_status_id: 123456, text: "tweet!") }

    before do
      Twitter::Client.any_instance.stub(:user_timeline).and_return([tweet])
      Munoh.any_instance.stub(:find_source_tweet).and_return("first tweet")
      Munoh.any_instance.stub(:find_source_owner).and_return("tweet owner")
      munoh.set_phrases
    end

    it { munoh.set_phrases }
    it { munoh.phrases.should have(1).items }
    it { munoh.phrases.first.keyword.should eq "first tweet" }
    it { munoh.phrases.first.reply.should eq "tweet!" }
  end

  describe "#find_source_tweet" do
    include_context "request_to_twitter_stub"

    let!(:munoh) { FactoryGirl.create(:munoh) }
    let!(:tweet) { Twitter::Tweet.new(id: 1, in_reply_to_status_id: 123456, text: "tweet!") }

    context "with not found exception" do
      before do
        Twitter::Client.any_instance.stub(:status).and_raise(Twitter::Error::NotFound)
      end

      it { munoh.find_source_tweet(tweet.in_reply_to_status_id).should be_nil }
    end

    context "with forbidden exception" do
      before do
        Twitter::Client.any_instance.stub(:status).and_raise(Twitter::Error::Forbidden)
      end

      it { munoh.find_source_tweet(tweet.in_reply_to_status_id).should be_nil }
    end

    context "without exception" do
      before do
        Twitter::Client.any_instance.stub(:status).and_return(tweet)
      end

      it { munoh.find_source_tweet(tweet.in_reply_to_status_id).should eq tweet.text }
    end
  end

  describe "#find_source_owner" do
    let!(:munoh) { FactoryGirl.build(:munoh) }
    let!(:twitter_user) { Twitter::User.new(id: 12345, name: "owner") }

    context "with not found exception" do
      before do
        Twitter::Client.any_instance.stub(:user).and_raise(Twitter::Error::NotFound)
      end

      it { munoh.find_source_owner(twitter_user.id).should be_nil }
    end

    context "with forbidden exception" do
      before do
        Twitter::Client.any_instance.stub(:user).and_raise(Twitter::Error::Forbidden)
      end

      it { munoh.find_source_owner(twitter_user.id).should be_nil }
    end

    context "without exception" do
      before do
        Twitter::Client.any_instance.stub(:user).and_return(twitter_user)
      end

      it { munoh.find_source_owner(twitter_user.id).should eq twitter_user.name }
    end

  end

  describe "#format_reply" do
    let!(:munoh) { FactoryGirl.build(:munoh) }

    context "with '@username'" do
      it { munoh.format_reply("hoge-user","hoge-user method test!").should eq "[user_name] method test!"}
    end

    context "without '@username'" do
      it { munoh.format_reply("hoge-user","method test!").should eq "method test!" }
    end

    context "with nil" do
      it { munoh.format_reply(nil, "method test!").should eq "method test!" }
    end
  end

  describe "#remove_noise" do
    let!(:munoh) { FactoryGirl.build(:munoh) }

    context "with 'http://hoge'" do
      it{munoh.remove_noise("http://hoge tweet!").should eq "tweet!"}
    end

    context "with '@hoge'" do
      it{munoh.remove_noise("@hoge tweet!").should eq "tweet!"}
    end
  end
end
