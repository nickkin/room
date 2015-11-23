class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :add_allow_credentials_headers
  def add_allow_credentials_headers
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
  end

  def options
    head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type'
  end

  private
  def not_authenticated
    redirect_to login_path, alert: "Пожалуйста войдите в систему"
  end
end
