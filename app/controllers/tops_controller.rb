class TopsController < ApplicationController
  def index
    @shops = Shop.all
    if params[:tag_name]
      @shops= @shops.tagged_with("#{params[:tag_name]}")
  end
end

  def omotesandou
  @shops = Shop.where(area: "表参道")
  end

  def coffee_stand
    @shops =Shop.tagged_with(["コーヒースタンド"])
  end

end
