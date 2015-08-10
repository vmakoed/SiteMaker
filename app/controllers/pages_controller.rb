class PagesController < ApplicationController
  TYPES = ["Text", "Video", "Gallery"]
	def new
    @user = User.find(params[:user_id])
    @page = @user.pages.new
  end

  def create
    @user = User.find(params[:user_id])
    @page = @user.pages.create(page_params)

    redirect_to edit_user_page_path(@user, @page)
  end

  def update
    @user = User.find(params[:user_id])
    @page = @user.pages.find(params[:id])
    @page.update_attributes(title: params["page"]["title"])

    if params["components"] && params["components"].size != 0
      components = start_processing_data()
      if components.is_a?(Array)
        if start_transaction(components)
          publish
        end
      else
        flash[:notice] = "Wrong params"
      end
    else
      @page.components.delete_all
      flash[:notice] = "All components destroyed"
    end
    Page.reindex
    Sunspot.commit
    respond_to do |format|
      format.html {redirect_to edit_user_page_path(@user, @page)}
      format.js {}
    end

    authorize! :manage, @page
  end

  def destroy
    @user = User.find(params[:user_id])
    @page = @user.pages.find(params[:id])
    @page.destroy
    redirect_to user_pages_path(@user)
  end

  def edit
    @user = User.find(params[:user_id])
    @page = @user.pages.find(params[:id])
    @image = @user.images.new

    authorize! :manage, @page
  end

  def index
    @user = User.find(params[:user_id])

    if @user != current_user && @user.role != "admin"
      @pages = @user.pages.reject { |r| r.published == 0 }
    else
      @pages = @user.pages
    end
  end

  def show
    @user = User.find(params[:user_id])
    @page = @user.pages.find(params[:id])
  end

  def welcome
    @pages = Page.all.reject { |r| r.published != 1 }
  end

  def start_processing_data
    components = params["components"]
    size = components.size
    set_of_components = []
    for i in "0"...size.to_s
      if components[i] && components[i].size == 1 && TYPES.any? {|k| components[i].key?(k)}
        type = TYPES.find{|type| components[i].key?(type)}
        if type == "Text"
          component = create_text(components[i][type])
        elsif type == "Video"
          component = create_video(components[i][type])
        elsif type == "Gallery"
          component = create_gallery(components[i][type])
        end
        component.order = i.to_i
        component.page_id = @page.id
        set_of_components << component
      else
        return nil
      end
    end
    set_of_components
  end

  private
    def page_params
      params.require(:page).permit(:title)
    end

    def start_transaction(components)
      Component.transaction do
        begin
          @page.components.delete_all
          components.each do |c|
            c.save!
          end
        rescue
          flash[:notice] = "Transaction failed"
        else
          flash[:notice] = "Сhanges have been made successfully"
        end
      end
    end

    def create_text(text_data)
      text = Text.new
      text.content = text_data
      text
    end

    def create_video(video_data)
      video = Video.new
      video.content = video_data
      video
    end

    def create_gallery(gallery_data)
      set_of_images = []
      gallery_data.each do |order, link|
        gallery_image = GalleryImage.new
        gallery_image.order = order.to_i
        gallery_image.link = link
        set_of_images << gallery_image
      end
      gallery = Gallery.new
      gallery.gallery_images << set_of_images
      gallery
    end

    def publish
      if params[:publish]
        @page.update_attributes(published: 1)
        flash[:notice] = "Your page has been saved and published"
      end

      if params[:hide]
        @page.update_attributes(published: 0)
        flash[:notice] = "Your page has been saved and hidden"
      end
    end
end
