class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user][:email], params[:user][:password])
      redirect_to root_path, notice: 'Удачный вход в систему'
    else
      flash.now[:alert] = 'Недачный вход'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Вы вышли из системы'
  end
end
