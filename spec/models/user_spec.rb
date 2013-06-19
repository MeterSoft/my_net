require "spec_helper"

describe User do
  let(:current_user) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }

  context 'associations' do
    it { should have_many(:friendships) }
    it { should have_many(:friends) }
    it { should have_many(:inverse_friendships) }
    it { should have_many(:created_posts) }
    it { should have_many(:received_posts) }
    it { should have_many(:posts) }
    it { should have_many(:groups) }
    it { should have_many(:group_user) }
    it { should have_one(:setting) }
  end

  context '#full_name' do
    it "should have fullname" do
      FactoryGirl.build(:user, first_name: "Eugene", last_name: "Korpan").full_name.should == "Eugene Korpan"
    end
  end

  context "#email" do
    it "should not have uniquens" do
      FactoryGirl.create(:user, email: "test@mail.ru").should be_true
      FactoryGirl.build(:user, email: "test@mail.ru").should_not be_valid
    end
  end

  context '#its_i?' do
    it "should verify by self" do
      current_user.its_i?(user).should be_false
    end
  end

  context "#friend?" do
    it "should not friend" do
      current_user.friend?(user).should be_false
    end

    it "should be friend" do
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: user.id, status: 'approved')
      user.friend?(current_user).should be_true
      current_user.friend?(user).should be_true
    end
  end

  context "#friend_invited?" do
    it "should not invite" do
      current_user.friend_invited?(user).should be_false
    end

    it "should be invite" do
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: user.id, status: 'pending')
      current_user.friend_invited?(user).should be_true
    end
  end

  context 'scope search' do
    let(:search_user) { FactoryGirl.create(:user, first_name: 'Vasya') }

    it 'should find users' do
      User.search('vasya', current_user.id).should eq([search_user])
    end
  end

  
end