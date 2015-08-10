class ComponentsController < ApplicationController
	def new
    @page = Page.find(params[:page_id])
    @component = @page.components.new
  end

  def create
    @page = Page.find(params[:page_id])
    @component = @page.components.create(component_params)

    redirect_to user_page_path(@page.user, @page)
  end

  def update
    @page = Page.find(params[:page_id])
    @component = @page.components.find(params[:id])

    if @component.update(component_params)
      redirect_to user_page_path(@page.user, @page)
    else
      render 'edit'
    end
  end

  def destroy
    @page = Page.find(params[:page_id])
    @component = @page.components.find(params[:id])
    @component.destroy
    redirect_to user_page_path(@page.user, @page)
  end

  def edit
    @page = Page.find(params[:page_id])
    @component = @page.components.find(params[:id])
  end

  def index
    @page = Page.find(params[:page_id])
    @components = @page.components
  end
  
  def show
    @page = Page.find(params[:page_id])
    @component = @page.components.find(params[:id])
  end

  private
    def component_params
      params.require(:component).permit(:content_type, :content, :order)
    end
end
