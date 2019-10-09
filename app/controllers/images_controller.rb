class ImagesController < ApplicationController
  def index
    @images = if params.key?(:tag)
                Image.order(created_at: :desc).tagged_with(params[:tag])
              else
                Image.order(created_at: :desc)
              end

    flash.now[:warning] = 'There is no image under this tag' if @images.blank?
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to @image, flash: { success: 'Image successfully created' }
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  def destroy
    @image = Image.find_by(id: params[:id])

    @image.destroy if @image.present?

    redirect_to images_path, flash: { success: 'Image successfully deleted' }
  end

  private

  def image_params
    params.require(:image).permit(:url, :tag_list)
  end
end
