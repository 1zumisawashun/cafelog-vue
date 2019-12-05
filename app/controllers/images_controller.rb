class ImagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @shop = Shop.find(params[:id])
    @images= Shop.find(params[:id]).images
    @image=@shop.images.build
    @comments = Shop.find(params[:id]).comments #コメントモデルを使えるようにしている
    @comment = @shop.comments.build #→これはコメントを入力するよう
    @like = Like.new
    @pictures = @shop.pictures#1個の投稿に対して複数の写真がある。それをインスタンス変数に格納
end

  def create
    shop = Shop.find(params[:shop_id])
    @image = shop.images.build(image_params)
    @image.user_id = current_user.id
    if @image.save
      flash[:success] = "写真を投稿しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:success] = "写真を投稿できませんでした"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @shop = Shop.find(params[:shop_id])
    @image = @shop.images.find(params[:id])
    @image.destroy
    redirect_to shop_path(@shop)
  end

  private
  def image_params
    params.require(:image).permit(:image)
  end
end
