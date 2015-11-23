class AdsController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :build_ad, only: [:create]
  before_action :load_ad,  only: [:edit, :update, :destroy]

  def index
    @from_yandex_map = params[:from] == "yandex_map"

    @ads = if @from_yandex_map
      Ad.where("location" => {"$within" => {"$box" => coordinates}})
    else
      Ad.page(params[:page]).per(5).where("location" => {"$within" => {"$box" => coordinates}})
    end
    if params[:min_price] && params[:max_price]
      @ads = @ads.where(:"price" => { :"$lte" => params[:max_price].to_f, :"$gte" => params[:min_price].to_f })
    end
    @ads.entries
  end

  def new
    @ad = Ad.new
  end

  def create
    @ad = Ad.new(ad_params)
    if @ad.save
      flash[:success] = 'объявление удачно создано'
      redirect_to edit_ad_path(@ad)
    else
      flash.now[:error] = 'объявление не создано'
      render :new
    end
  end

  def update
    @ad.update(ad_params)
    if @ad.save
      flash[:success] = 'объявление удачно изменено'
      render :edit
    else
      flash.now[:error] = 'объявление не изменено'
      render :edit
    end
  end

  def edit
  end

  def destroy
    @ad.destroy
    redirect_to new_ad_path
  end

private

  def load_ad
    @ad = Ad.find(params[:id])
  end

  def ad_params
    params.require(:advertising).permit(:name, :description, :address, :price, :location, :image_preview).tap do |a|
      if a[:location].present?
        a[:location] = a[:location].split(' ').map(&:to_f)
      else
        a[:location] = nil
      end
    end
  end

  def coordinates
    begin
      c = params[:bbox].split(',').map(&:to_f)
      [ [c[0], c[1]],[c[2], c[3]] ]
    rescue
      [[55.44081385404796,36.769773301146316],[56.04659110740895,38.74181919958385]] #москва
    end
  end
end
