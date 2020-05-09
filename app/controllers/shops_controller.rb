class ShopsController < ApplicationController
  #before_action :authenticate_user!
  #ログインしていなかったらshopsコントローラを使うことができない。つまり必然的にshopsコントローラも使うことができない。
  def search
    @shops = Shop.search(params[:search])
  end



  def index
    @shops = Shop.limit(8).order('id DESC') #.page(params[:page]).per(4) ページネーションするときに必要な記載内容
    @area = Shop.where(area: "渋谷").limit(8)
    @tags =Shop.tagged_with(["wi-fi"]).limit(8)
    @score= Comment.average(:score)
    @images=Picture.all #これでランダム設定できている→確認済み
    @all= Shop.all


    @hutakotamagawa=Shop.where(area:"二子玉川")
    @shibuya=Shop.where(area:"渋谷")
    @daikanyama=Shop.where(area:"代官山")
    @omotesandou=Shop.where(area:"表参道")
    @nakameguro=Shop.where(area:"中目黒")
    @asakusa=Shop.where(area:"浅草")
    @nishiogikubo=Shop.where(area:"西荻窪")
    @sangendyaya=Shop.where(area:"三軒茶屋")
  end

  def show
    @shop = Shop.find(params[:id])
    @images= Shop.find(params[:id]).images
    @image=@shop.images.build
    @comments = Shop.find(params[:id]).comments #コメントモデルを使えるようにしている
    @comment = @shop.comments.build #→これはコメントを入力するよう
    @like = Like.new
    @pictures = @shop.pictures#1個の投稿に対して複数の写真がある。それをインスタンス変数に格納
  end
  #ブロック要素にtがあるのはマイグレーションファイルですでに定義されているから
  #インスタンス変数はcontrollerを超えて扱うことができた→テーブルの中身はアソシエーションしないといけないのかも。
  #マイページへ飛ばすリンクを作成する時、がうまく読み込みできなかったのでprefixを使用しています。
  def new
    @shop=Shop.new
    4.times{@shop.pictures.build}
  end

  def create
  @shop=Shop.new(shop_params)
  @shop.user_id= current_user.id
    respond_to do |format|
      if @shop.save
        params[:pictures]['picture'].each do |a| #ネストしたpictureをレコード1つ1つに保存している、params[:pictures]["picture"]→ユーザーが入力した内容
            @picture=@shop.pictures.create!(:picture => a, :shop_id => @shop.id, :user_id =>current_user.id)
        end
      format.html {redirect_to @shop, notice: 'Shop was successfully  created.'}
      else
      format.html { render action: 'index'}
      end
    end
  end

  def edit
    @shop=Shop.find(params[:id])#これのparamsはレコードに入っているidを拾ってくる
    if @shop.pictures.count == 0#デフォルト値を入れて必ず4つ持ってくるので必要ない
          4.times { @shop.pictures.build }
        elsif @shop.pictures.count == 1
          3.times { @shop.pictures.build }
        elsif @shop.pictures.count == 2
          2.times { @shop.pictures.build }
        elsif @shop.pictures.count == 3
          1.times { @shop.pictures.build }
        elsif @shop.pictures.count == 4
          0.times { @shop.pictures.build }
        end
  end

  def update
    @shop = Shop.find(params[:id]) #これのparamsはユーザが入力した内容を拾ってくる
        if @shop.update(shop_params) #なんでupdateではなくattributes_updateなのか？
          @shop.pictures.each(&:destroy)
          params[:pictures]['picture'].each do |a| #ネストしたpictureをレコード1つ1つに保存している、params[:pictures]["picture"]→ユーザーが入力した内容
              @picture=@shop.pictures.create!(:picture => a, :shop_id => @shop.id, :user_id =>current_user.id)
            end
           redirect_to @shop
           else
           render action: 'index'
          end #if文の時のendを忘れることが非常に多いからマジで気を付けること
  end

  def destroy
    @shop = Shop.find(params[:id])
    @shop.destroy
    redirect_to shops_path
  end

  private
  def shop_params
    params.require(:shop).permit(:name,:area,:menu,:price,:review,:tag_list,:address, :station, :opening_hour ,:phone, :url,:latitude,:longitude, pictures_attributes: [:id,:shop_id,:picture] )
  end

  end
