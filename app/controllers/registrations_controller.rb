class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  rescue ActiveRecord::RecordNotUnique => e
    render json: { message: 'Record already exists'}, status: :bad_request
  end
end