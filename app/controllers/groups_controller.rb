class GroupsController < ApplicationController
  SHOW_POSTS_COUNT = 10

  before_filter :find_group, :only => [:show, :edit, :update, :destroy, :search_users]
  before_filter :check_permissions, only: [:edit, :update]


  def index
    @unconnected_groups = current_user.unconnected_groups
    @created_groups = current_user.created_groups
    @member_of_groups = current_user.member_of_groups
  end

  def new
  	@group = Group.new
  end

  def show
    @groups = current_user.created_groups | current_user.member_of_groups
    @posts = Kaminari.paginate_array(@group.posts.reverse).page(params[:page] || 1).per(SHOW_POSTS_COUNT)
    @members = @group.users
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

  def join_user
    @groupuser = GroupUser.create(group_id: params[:group_id], user_id: params[:user_id])
    redirect_to :back
  end

  def leave_user
    @groupuser = GroupUser.where(group_id: params[:group_id], user_id: params[:user_id]).first
    @groupuser.destroy
    redirect_to :back
  end

  def search_users
    search = params[:search].split(' ')
    @users = User.where('lower(first_name) IN(lower(?)) OR lower(last_name) IN(lower(?))', search, search).where('id != ?', current_user.id)
    respond_to do |format|
      format.js { render layout: false }
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
