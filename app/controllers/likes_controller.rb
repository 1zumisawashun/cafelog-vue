class LikesController < ApplicationController
  before_action :set_shop, only: [:create, :destroy]

  def create
    @like = current_user.likes.create(shop_id: params[:shop_id])
    redirect_to shop_path(@shop)
  end

  def destroy
    @like = Like.find_by(shop_id: params[:shop_id]) #shop_idはフォームから受け取ることができないから記載する必要がある
    @like.destroy
    redirect_to root_path
  end

  private
  def set_shop
    @shop = Shop.find(params[:shop_id])
    #shop_idが急に使えるのはrouteでネストされているからかもしれない
    #というか絶対にネストしているからであるだろう。
  end




end
