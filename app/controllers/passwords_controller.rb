class PasswordsController < ApplicationController

def forgot
    if params[:email].blank? # check if email is present
      return render json: {error: 'Email not present'}
    end

    user = User.find_by(email: params[:email]) # if present find user by email

    if user.present?
      user.generate_password_token! #generate pass token
      render json: {message: 'Token generated',token: user.reset_password_token}, status: :ok
    else
      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s
    
    render json: {error: 'Token not present'} and return if token.blank?

    user = User.find_by(reset_password_token: token)

    render json: {error: 'Password cannot be blank'}  and return if params[:password].blank?

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: {message: 'Success'}, status: :ok
      else
        render json: {error: user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
    end
  end

end
