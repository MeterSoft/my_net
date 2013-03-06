class SessionsController < ApplicationController

  skip_before_filter :authenticate_user!

  layout "login"

  def new
    srand
    session[:state] ||= Digest::MD5.hexdigest(rand.to_s)
    @vk_url = VkontakteApi.authorization_url(scope: [:friends, :photos, :audio, :video, :offline, :notify], state: session[:state])
  end

  def callback
    # проверка state
    if session[:state].present? && session[:state] != params[:state]
      redirect_to root_url
    end

    # получение токена
    @vk = VkontakteApi.authorize(code: params[:code])
    # и сохранение его в сессии
    session[:token] = @vk.token
    # также сохраним id пользователя на ВКонтакте - он тоже пригодится
    session[:vk_id] = @vk.user_id

    get_information

  end

  def get_information
    # сначала создадим клиент API
    vk = VkontakteApi::Client.new(session[:token])


    # теперь получим текущего юзера
    @user = vk.users.get(uid: session[:vk_id], fields: [:screen_name, :photo]).first
    @new_user = User.find_or_create(id: session[:vk_id], first_name: name_for(@user), avatar: avatar_for(@user))
    session[:user_id] = @new_user.id
    # его друзей
    @friends = vk.friends.get(fields: [:screen_name, :sex, :photo, :last_seen])
    # отдельно выберем тех, кто в данный момент онлайн
    @friends_online = @friends.select { |friend| friend.online == 1 }

    # группы
    @groups = vk.groups.get(extended: 1)
    # первый элемент массива - кол-во групп; его нужно выкинуть
    @groups.shift

    # и ленту новостей
    raw_feed = vk.newsfeed.get(filters: 'post')
    # обработанную в отдельном методе
    @newsfeed = process_feed(raw_feed)

    redirect_to main_page_path(@new_user)
  end


  def destroy
    session[:token] = nil
    session[:vk_id] = nil

    redirect_to root_url
  end

end