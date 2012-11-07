require 'spec_helper'

describe MyTwitterClient do
  let(:client) { MyTwitterClient.new("test") }
  describe "#find_source_tweet" do
    include_context "request_to_twitter_stub"

    let!(:tweet) { Twitter::Tweet.new(id: 1, in_reply_to_status_id: 123456, text: "tweet!") }
    named_let(:extracted_tweet) { tweet.text }

    subject{ client.find_source_tweet(tweet.in_reply_to_status_id) }

    context "raise exception" do
      context "not found" do
        before do
          Twitter::Client.any_instance.stub(:status).and_raise(Twitter::Error::NotFound)
        end
        it { should be_nil }
      end

      context "forbidden" do
        before do
          Twitter::Client.any_instance.stub(:status).and_raise(Twitter::Error::Forbidden)
        end

        it { should be_nil }
      end
    end

    context "no exception" do
      before do
        Twitter::Client.any_instance.stub(:status).and_return(tweet)
      end

      it { should eq extracted_tweet }
    end
  end

  describe "#find_source_owner" do
    let!(:twitter_user) { Twitter::User.new(id: 12345, name: "owner") }
    named_let(:extracted_user_name) { twitter_user.name }

    subject{ client.find_source_owner(twitter_user.id) }

    context "raise exception" do
      context "not found" do
        before do
          Twitter::Client.any_instance.stub(:user).and_raise(Twitter::Error::NotFound)
        end

        it { should be_nil }
      end

      context "forbidden" do
        before do
          Twitter::Client.any_instance.stub(:user).and_raise(Twitter::Error::Forbidden)
        end

        it { should be_nil }
      end
    end
    context "no exception" do
      before do
        Twitter::Client.any_instance.stub(:user).and_return(twitter_user)
      end

      it { should eq extracted_user_name }
    end
  end

  describe "#format_reply" do
    context "with '@username'" do
      it { client.format_reply("hoge-user","hoge-user method test!").should eq "[user_name] method test!"}
    end

    context "without '@username'" do
      it { client.format_reply("hoge-user","method test!").should eq "method test!" }
    end

    context "with nil" do
      it { client.format_reply(nil, "method test!").should eq "method test!" }
    end
  end

  describe "#remove_noise" do
    context "with 'http://hoge'" do
      it { client.remove_noise("http://hoge tweet!").should eq "tweet!" }
    end

    context "with '@hoge'" do
      it { client.remove_noise("@hoge tweet!").should eq "tweet!" }
    end
  end
end
