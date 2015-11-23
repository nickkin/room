class AdvertisingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_login, except: [:index]
  before_action :load_advertising,  only: [:edit, :update, :destroy]


  def index
    @from_yandex_map = params[:from] == "yandex_map"

    @advertisings = if @from_yandex_map
      Advertising.where("location" => {"$within" => {"$box" => coordinates}})
    else
      Advertising.page(params[:page]).per(5).where("location" => {"$within" => {"$box" => coordinates}})
    end
    if params[:min_price] && params[:max_price]
      @advertisings = @advertisings.where(:"price" => { :"$lte" => params[:max_price].to_f, :"$gte" => params[:min_price].to_f })
    end
    @advertisings.entries
  end

  def new
    @advertising = Advertising.new
  end

  def create
    @advertising = current_user.advertisings.new(advertising_params)
    if @advertising.save
      flash[:success] = 'объявление удачно создано'
      redirect_to edit_advertising_path(@advertising)
    else
      flash.now[:error] = 'объявление не создано'
      render :new
    end
  end

  def update
    @advertising.update(advertising_params)
    if @advertising.save
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
    @advertising.destroy
    redirect_to root_path
  end

private

  def load_advertising
    @advertising = current_user.advertisings.where(id: params[:id]).first
    unless @advertising
      redirect_to root_path, flash: {error: "Ваше объявление не найдено"}
    end
  end

  def advertising_params
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
