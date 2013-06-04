class GroupsController < ApplicationController
  before_filter :find_group, :only => [:show, :edit, :update, :destroy]
  before_filter :check_permissions, only: [:edit, :update]


  def index
    @groups = Group.all
    @my_admins_groups = Group.where(admin_id: current_user[:id])
    @my_groups = current_user.groups
  end

  def new
  	@group = Group.new
  end

  def show
  end

  def create
  	@group = Group.create(params[:group])
  	@group.admin_id = current_user.id
  	if @group.save
      current_user.group_user.create!(group_id: @group.id)
  		redirect_to group_path(@group)
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    @group.update_attributes(params[:group])
    if @group.save
      redirect_to group_path(@group)
    end
  end

  def destroy
  	if @group.destroy
  		redirect_to groups_path
  	end
  end

  def join
    @groupuser = GroupUser.create(group_id: params[:group_id], user_id: current_user.id)
    if @groupuser.save
      redirect_to groups_path
    else
      redirect_to root_path
    end
  end

  def leave
    @groupuser = GroupUser.where(group_id: params[:group_id], user_id: current_user.id).first
    if @groupuser.destroy
      redirect_to groups_path
    else
      redirect_to root_path
    end
  end

  private
  def find_group
    @group = Group.find(params[:id])
  end

  def check_permissions
    redirect_to groups_path if @group.admin_id != current_user[:id]
  end

end
