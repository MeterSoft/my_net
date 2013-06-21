require 'spec_helper'

describe GroupUser do

	context 'associations' do
	  it { should belong_to(:user) }
	  it { should belong_to(:group) }
	end
	
end