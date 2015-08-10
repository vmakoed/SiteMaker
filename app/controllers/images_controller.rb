class ImagesController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @image = @user.images.new
  end

  def create
    @user = User.find(params[:user_id])
    @image = @user.images.create(image_params)

    respond_to do |format|
      format.html {redirect_to user_images_path(@user)}
      format.js
    end

  end

  def index
    @user = User.find(params[:user_id])
    @images = @user.images.reverse
  end

  def show
    @user = User.find(params[:user_id])
    @image = @user.images.find(params[:id])
  end

  def destroy
    @user = User.find(params[:user_id])
    @image = @user.images.find(params[:id])
    @image.destroy
    Cloudinary::Api.delete_resources(['image1', 'image2'])
    redirect_to user_images_path(@user)
  end

  private
    def image_params
      params.require(:image).permit(:url)
    end
end