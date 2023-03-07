class Api::V1::Publications::ConvenantsController < ActionController::API

  before_action :verify_resource_found

  def turn_on_confidential
    turn_resource true
  end

  def turn_off_confidential
    turn_resource false
  end

  
  private

  def param_isn_sic
    params[:isn_sic]
  end

  def resource
    model_klass.find_by_isn_sic(param_isn_sic)
  end

  def model_klass
    Integration::Contracts::Convenant
  end

  def turn_resource(value)
    begin
      ActiveRecord::Base.transaction do
        update_confidential(value)  
      end
    rescue => e
      render json: { error:  e.message }
    end
  end

  def update_confidential(confidential)
    if resource.update(confidential: confidential)
      
      remove_obts(resource)
      remove_instrument_document(resource) #integra/descricao_url
      remove_work_plan_attachments(resource)
      remove_additive_document(resource) #integra/descricao_url
      remove_adjustments_document(resource) 
      
      render json: { 
        id: resource.id, 
        confidential: resource.confidential 
      }

    else
      render json: resource.errors.to_json
    end
  end

  def verify_resource_found
    return render json: resource_not_found if !resource.present?
  end

  def resource_not_found
    { error: "Resource not found with isn_sic: #{param_isn_sic}" }
  end

  def remove_obts(resource)
    resource.transfer_bank_orders.delete_all
  end

  # Remove Integra do instrumento / descricao_url
  def remove_instrument_document(resource)
    # "descricao_url", "descricao_url_pltrb", "descricao_url_ddisp", "descricao_url_inexg"
    resource.update(descricao_url: nil, descricao_url_pltrb: nil, descricao_url_ddisp: nil, descricao_url_inexg: nil, cod_plano_trabalho: nil)
  end

  def remove_work_plan_attachments(resource)
    resource.work_plan_attachments.destroy_all
  end

  def remove_additive_document(resource)
    resource.additives.update_all(descricao_url: nil)
  end

  def remove_adjustments_document(resource)
    resource.adjustments.update(descricao_url: nil)
  end

end
