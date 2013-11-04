require 'spec_helper'

describe Mention do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { @mention = Mention.new(user: other_user, post_id: 0) }

  subject { @mention }

  it { should respond_to(:user) }
  it { should respond_to(:post) }

  it { should be_valid }

  describe "when user is not present" do
  	before { @mention.user = nil }
  	it { should_not be_valid }
  end

  describe "when post is not present" do
  	before { @mention.user = nil }
  	it { should_not be_valid }
  end
end
