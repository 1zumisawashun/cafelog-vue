class CommentsController < ApplicationController

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
    @comment = shop.comments.build(comment_params)
    @comment.user_id = current_user.id #上記の2行だけではユーザの関連付けができないため
    if @comment.save
      redirect_back(fallback_location: root_path) #これをredirect_to("/shops/index")にしたらバグった。
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @shop = Shop.find(params[:shop_id])
    @comment = @shop.comments.find(params[:id])
    @comment.destroy
    redirect_to shop_path(@shop)
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :score)
  end
end
