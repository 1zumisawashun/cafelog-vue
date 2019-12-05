class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @shops = Shop.where(user_id: current_user.id)
    @likes= Like.where(user_id: @user.id)
    #@shop =@user.shops.build  #これはユーザが投稿したshopを新規生成しインスタンス変数に格納→shops#createへ
    #これをしないと/user/user_id/shop/idにならない
    #@shops=@user.shops #userが投稿したshopをインスタンス変数に格納
  end

  def edit
    @user= current_user
  end

  def update
    @user=current_user
    @user.assign_attributes(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :user_image)
  end
end

#deviseで作ったuserモデルとかはusersコントローラでは操作できない→もう一度suerモデルを作成する必要はあるのかわからない。
