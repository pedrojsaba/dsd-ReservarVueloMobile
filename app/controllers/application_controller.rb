class ApplicationController < ActionController::Base
  protect_from_forgery

  def ruta_wdsl
  	RUTAS_WDSL[Rails.env]["path"]
  end

end
