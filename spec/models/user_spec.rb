require 'spec_helper'

describe User do
  
  before { @user = FactoryGirl.create(:user) }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }

  it { should respond_to(:username) }

  it { should be_valid }
  it { should_not be_admin }

  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when password is not present" do
  	before { @user = User.new(name: "Example User", email: "user@example.com", password: " ", password_confirmation: " ") }
  	it { should_not be_valid }
  end

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }
  end

  describe "with a password that's too short" do
  	before { @user.password = @user.password_confirmation = "a" * 5 }
  	it { should_not be_valid }
  end

  describe "with a username that's too long" do
    before { @user.username = "a" * 21 }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) { User.find_by(email: @user.email) }

  	describe "with valid password" do
  	  it { should eq found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  	  let(:user_for_invalid_password) { found_user.authenticate("invalid") }

  	  it { should_not eq user_for_invalid_password }
  	  specify { expect(user_for_invalid_password).to be_false }
  	end
  end

  describe "when name is too long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  	  addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
  	  addresses.each do |invalid_address|
  	  	@user.email = invalid_address
  	  	expect(@user).not_to be_valid
  	  end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  	  addresses = %w[user@foo.COM A_US-ER@f.b.org frst.last@foo.jp a+b@baz.cn]
  	  addresses.each do |valid_address|
  	  	@user.email = valid_address
  	  	expect(@user).to be_valid
  	  end
  	end
  end

  describe "when username format is invalid" do
    it "should be invalid" do
      usernames = ["94name", "__name", "my__name", "my name", "my.name"]
      usernames.each do |invalid_username|
        @user.username = invalid_username
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when username format is valid" do
    it "should be valid" do
      usernames = ["_myname67", "myname34", "my_name", "_my_67_name"]
      usernames.each do |valid_username|
        @user.username = valid_username
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    let(:me) { User.create(username: "username", email: "trb1992@gmail.com", name: "Taylor Brushwyler", password: "foobar", password_confirmation: "foobar") }
    let(:imposter) { User.create(username: "imposter", email: "trb1992@gmail.com", name: "I'm an imposter", password: "password", password_confirmation: "password") }

  	before do
  	  imposter.email.upcase!
  	  imposter.save
  	end

    subject { me }
  	it { should_not be_valid }
  end

  describe "when username is already taken" do
    let(:me) { User.create(username: "tbrushwyler", email: "trb1992@gmail.com", name: "Taylor Brushwyler", password: "foobar", password_confirmation: "foobar") }
    let(:imposter) { User.create(username: "tbrushwyler", email: "imposter@tor.com", name: "I'm an imposter", password: "password", password_confirmation: "password") }

    before do
      imposter.username.upcase!
      imposter.save
    end

    subject { me }
    it { should_not be_valid }
  end

  describe "remember_token" do
    before { @user.save }

    its(:remember_token) { should_not be_blank }
  end

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
  end
end
