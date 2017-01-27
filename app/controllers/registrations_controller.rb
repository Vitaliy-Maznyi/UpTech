class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_filter :not_allowed, only: :new

  def not_allowed
    raise MethodNotAllowed
  end

  private

  def sign_up_params
    params.require(:user).permit([
                                     :username,
                                     :password,
                                     :password_confirmation,
                                 ])
  end
end
