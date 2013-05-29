class GroupsController < ApplicationController
  def index
  	@groups = Group.all
  end

  def new
  	@group = Group.new
  end

  def show
  	@group = Group.find(params[:id])
  end

  def create
  	@group = Group.create(params[:group])
  	@group.user_id = current_user.id
  	if @group.save
  		redirect_to group_path(@group)
  	else
  		render 'new'
  	end
  	
  end

  def destroy
  	@group = Group.find(params[:id])
  	if @group.destroy
  		redirect_to groups_path
  	end
  end
end
