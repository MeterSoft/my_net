require "spec_helper"

describe User do
  let(:current_user) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }

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
      user.its_i?(current_user).should be_false
    end
  end

  context "#friend?" do
    it "should not friend" do
      user.friend?(current_user).should be_false
    end

    it "should be friend" do
      FactoryGirl.create(:friend, user_id: current_user.id, user_friend_id: user.id, status: 'confirmed')
      user.friend?(current_user).should be_true
    end
  end

  context "#friend_invited?" do
    it "should not invite" do
      user.friend_invited?(current_user).should be_false
    end

    it "should be invite" do
      FactoryGirl.create(:friend, user_id: current_user.id, user_friend_id: user.id, status: 'invite')
      user.friend_invited?(current_user).should be_true
    end
  end
end