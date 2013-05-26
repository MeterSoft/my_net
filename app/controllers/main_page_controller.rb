class MainPageController < ApplicationController
  SHOW_POSTS_COUNT = 10

  def index
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.all.reverse
    @posts = Kaminari.paginate_array(@posts).page(params[:page] || 1).per(SHOW_POSTS_COUNT)
  end

  def user_connections
    users = []
    User.all.each do |user|
      users << { name: user.full_name, avatar: user.avatar.url(:small), url: main_page_path(user) }
    end

    connections = []
    User.all.each_with_index do |user, user_i|
      User.all.each_with_index do |u, u_i|
        connections << { source: user_i,target: u_i, value: 12 } if user.friend?(u)
      end
    end

    render :json => { nodes: users, links: connections }
  end

end
