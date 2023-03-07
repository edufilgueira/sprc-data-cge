class Api::V1::Publications::BaseController  < ActionController::API

	before_action :skip_session

  PERMITTED_PARAMS = []

	def create
    return render json: { status: 'item has published' } if resource.persisted?
    if resource.update(resource_params)
      render json: { id: resource.id }
    else
      render json: resource.errors.to_json
    end
  end

  def destroy
    return render json: { status: 'item not found' } unless resource.persisted?

    if resource.destroy
      render json: { status: 'item destroyed' }
    else
      render json: resource.errors.to_json
    end
  end

  def resource_params  
    if params[base_param_name].present?
      params.require(base_param_name).permit(self.class::PERMITTED_PARAMS)
    elsif params[finder_column].present?
      params.permit(finder_column)
    end
  end

  def resource

    @resource ||= klass.unscoped.find_or_initialize_by(finder_column => resource_params[finder_column])
  end

  def base_param_name
    controller_name.singularize
  end

  def skip_session
    # Skip sessions and cookies for api
    request.session_options[:skip] = true
  end

  def klass
    "Integration::Contracts::#{model_name}".constantize
  end

  def model_name
    controller_name.singularize.camelize
  end

  def finder_column
    :isn_sic
  end

end