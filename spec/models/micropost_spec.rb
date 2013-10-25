require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should respond_to(:in_reply_to_user) }
  it { should respond_to(:in_reply_to_post) }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @micropost.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank content" do
  	before { @micropost.content = " " }
  	it { should_not be_valid }
  end

  describe "with content that is too long" do
  	before { @micropost.content = "a" * 141 }
  	it { should_not be_valid }
  end

  describe "with reply" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:reply) { other_user.microposts.build(content: "Good idea", in_reply_to_post: @micropost.id, in_reply_to_user: user.id) }

    it { should be_valid }
  end
end
