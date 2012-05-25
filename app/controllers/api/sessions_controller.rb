class Api::SessionsController < Devise::SessionsController

  prepend_before_filter :require_no_authentication, :only => :create
  prepend_before_filter :allow_params_authentication!, :only => :create

  def create
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    respond_to do |format|
      format.json { render :json => {:auth_token => resource.authentication_token} }
    end
  end

  def new
     render :text=>"Ok"
  end

end