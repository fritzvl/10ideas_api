class Api::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        respond_to do |format|
          format.json { render :json => {:auth_token => resource.authentication_token} }
        end
      else
        respond_to do |format|
          format.json { render :json => {:error => "User had been blocked"} , :status=> :unprocessable_entity}
        end
      end
    else
      clean_up_passwords resource
      respond_to do |format|
        format.json { render :json => {:errors => resource.errors.to_json} , :status=> :unprocessable_entity}
      end
    end

  end


  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if resource.update_with_password(params[resource_name])
      respond_to do |format|
        format.json { render :json => {:result => "ok"} }
      end
    else
      respond_to do |format|
        format.json { render :json => {:errors => resource.errors.to_json} , :status=> :unprocessable_entity}
      end
    end
  end

end
