require 'spec_helper'

describe Answer do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { user.microposts.build(content: "What's the capital of the US?") }
  let(:answer) { Answer.new(micropost: post, text: "Washington, DC") }

  subject { answer }
  it { should respond_to(:micropost) }
  it { should respond_to(:text) }

end
