class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.save!
    flash[:success] = 'Пользователь создан'
    redirect_to root_path

  rescue Mongoid::Errors::Validations
    flash.now[:error] = 'Пользователь не создался'
    render :new
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end