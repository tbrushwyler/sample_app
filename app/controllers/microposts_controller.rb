class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy, :show, :feed_show]
  before_action :correct_user, only: :destroy

  layout "click_through_layout", except: [:create]

  def create
  	@micropost = current_user.microposts.build(micropost_params)

  	if @micropost.save
  	  flash[:success] = "Micropost created!"
  	  redirect_to root_url
  	else
      @feed_items = []
  	  render 'static_pages/home'
  	end
  end

  def show
    @micropost = Micropost.find(params[:id])
    @next = Micropost.offset(rand(Micropost.count)).first
    @previous = Micropost.offset(rand(Micropost.count)).first
  end

  def feed_show
    @feed_items = current_user.feed
    @micropost = Micropost.find(params[:id])
    
    index = @feed_items.find_index(@micropost)
    if index.nil?
      render 'static_pages/home'
    else
      @next = @feed_items[index + 1] || @feed_items[0]
      @previous = @feed_items[index - 1]

      @next_path = feed_path @next
      @previous_path = feed_path @previous
      render 'microposts/show'
    end
  end

  def advanced_show
    if params[:source] == "feed"
      @feed_items = current_user.feed  
    elsif user = User.find_by_username(params[:source])
      @feed_items = user.microposts
    else
      @feed_items = Micropost.all
    end

    @micropost = Micropost.find(params[:id])
    
    index = @feed_items.find_index(@micropost)
    if index.nil?
      render 'static_pages/home'
    else
      @next = @feed_items[index + 1] || @feed_items[0]
      @previous = @feed_items[index - 1]

      @next_path = show_path @next, params[:source]
      @previous_path = show_path @previous, params[:source]
      render 'microposts/show'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private
  	def micropost_params
  	  params.require(:micropost).permit(:content, answers_attributes: [:text])
  	end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end