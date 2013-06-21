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
    it { should have_many(:groups).through(:group_user) }
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

  context '#all_friends' do
    let(:friend_user) { FactoryGirl.create(:user) }
    
    it 'should return all friends' do
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: user.id, status: 'approved')
      FactoryGirl.create(:friendship, user_id: friend_user.id, friend_id: current_user.id, status: 'approved')
      
      current_user.all_friends.should eq([user, friend_user])
    end
  end

  context '#approved_friends' do
    let(:friend_user) { FactoryGirl.create(:user) }
    
    it 'should return approved friends' do
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: user.id, status: 'approved')
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: friend_user.id, status: 'pending')
      
      current_user.approved_friends.should eq([user])
    end
  end

  context '#approved_inverse_friends' do
    let(:friend_user) { FactoryGirl.create(:user) }
    
    it 'should return approved inverse friends' do
      FactoryGirl.create(:friendship, user_id: user.id, friend_id: current_user.id, status: 'approved')
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: friend_user.id, status: 'approved')
      
      current_user.approved_inverse_friends.should eq([user])
    end
  end

  context '#pending_friends' do
    let(:friend_user) { FactoryGirl.create(:user) }
    
    it 'should return pending friends' do
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: user.id, status: 'pending')
      FactoryGirl.create(:friendship, user_id: friend_user.id, friend_id: current_user.id, status: 'pending')
      
      current_user.pending_friends.should eq([user])
    end
  end

  context '#pending_inverse_friends' do
    let(:friend_user) { FactoryGirl.create(:user) }
    
    it 'should return pending inverse friends' do
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: user.id, status: 'pending')
      FactoryGirl.create(:friendship, user_id: friend_user.id, friend_id: current_user.id, status: 'pending')
      
      current_user.pending_inverse_friends.should eq([friend_user])
    end
  end

  context '#friendship_with' do
    let(:friend_user) { FactoryGirl.create(:user) }
    
    it 'should return friendship' do
      FactoryGirl.create(:friendship, user_id: current_user.id, friend_id: user.id, status: 'pending')
      FactoryGirl.create(:friendship, user_id: friend_user.id, friend_id: current_user.id, status: 'pending')
      
      current_user.friendship_with(user).should eq(current_user.friendships.first)
    end
  end

  context '#avatar_url' do    
    it 'should return url user avatar' do      
      current_user.avatar_url.should eq(current_user.avatar.url(:small))
    end
  end

  context '#status' do
    let(:status_user) { FactoryGirl.create(:user) }

    it 'should return online status' do
      current_user.update_attributes(time: Time.now)      
      current_user.status.should eq('online')
    end

    it 'should return offline status' do
      current_user.update_attributes(time: Time.now - 100)      
      current_user.status.should eq('offline')
    end
  end

  context 'created_groups' do
    let(:group) { FactoryGirl.create(:group, admin_id: user.id) }
    let!(:group_users) { FactoryGirl.create(:group_user, user_id: user.id, group_id: group.id) }
    it 'should return true' do
      # user.groups << group
      user.created_groups.empty?.should be_false
    end

    it 'should return false' do
      current_user.created_groups.empty?.should be_true
    end
  end

  context 'member_of_groups' do
    let(:group) { FactoryGirl.create(:group, admin_id: user.id) }
    let!(:group_users) { FactoryGirl.create(:group_user, user_id: current_user.id, group_id: group.id) }
    it 'current_user should be member of group' do
      current_user.member_of_groups.should_not be_empty
    end

    it 'user should_not be member of group' do
      user.member_of_groups.should be_empty
    end
  end

  context 'unconnected_groups' do
    let(:group) { FactoryGirl.create(:group, admin_id: user.id) }
    let!(:group_users) { FactoryGirl.create(:group_user, user_id: user.id, group_id: group.id) }
    it 'should be unconnected to groups' do
      current_user.unconnected_groups.first.should_not eq(current_user.member_of_groups)
    end

    it 'should_not be admin of group' do
      current_user.unconnected_groups.first.admin_id.should_not eq(current_user.id) 
    end

    it 'should_not be in group_user table' do
      group_users.user_id.should_not eq(current_user.id)
    end

  end

end