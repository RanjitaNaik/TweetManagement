class ApplicationController < ActionController::API
  include Pundit
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end

  private

  def record_not_found(exception)
    render json: { message: 'Not found' }, status: :not_found
  end

  def not_authorized(exception)
    render json: { message: 'Unauthorized' }, status: :forbidden
  end
end