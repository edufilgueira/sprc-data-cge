class Api::V1::ImportersController < ActionController::API

  before_action :skip_session

  def create
    Integration::Importers::Import.call(params[:id], params[:configuration_id])
  end

  # Private

  private

  ## Methods

  def skip_session
    # Skip sessions and cookies for api
    request.session_options[:skip] = true
  end
end
