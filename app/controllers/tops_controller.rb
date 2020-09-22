class TopsController < ApplicationController
  def index
    @shops = Shop.all
    if params[:tag_name]
      @shops= @shops.tagged_with("#{params[:tag_name]}")
  end
end

def about
end
end
