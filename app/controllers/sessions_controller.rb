class SessionsController < ApplicationController
  def create
    auth = request.env['rack.auth']
    Rails.logger.info auth.inspect
    self.current_user = Authorization.find_or_create_from_hash(auth)
    render :text => "Welcome, #{current_user.name}."
  end
end