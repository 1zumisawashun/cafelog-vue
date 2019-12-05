class PicturesController < ApplicationController
  before_action :authenticate_user!

  def show
    @shop = shop.find(params[:id])
    @user = @shop.user
  end

  def create
    shop = Shop.find(params[:shop_id])
    @picture = shop.pictures.build(picture_params)
    @picture.user_id = current_user.id
    if @picture.save
      flash[:success] = "写真を投稿しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:success] = "写真を投稿できませんでした"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @shop = Shop.find(params[:shop_id])
    @picture = @shop.pictures.find(params[:id])
    @picture.destroy
    redirect_to shop_path(@shop)
  end

  private
  def picture_params
    params.require(:picture).permit(:picture)
  end
end
