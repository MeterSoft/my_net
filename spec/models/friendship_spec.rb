require 'spec_helper'

describe Friendship do
	context "associations" do
		it { should belong_to(:user) }
		it { should belong_to(:friend) }
	end
end
