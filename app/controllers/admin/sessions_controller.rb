module Admin
  class SessionsController < ApplicationController
    allow_unauthenticated_access only: %i[new create]
    layout "auth", only: :new
    rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_admin_session_path, alert: "Try again later." }

    def new
    end

    def create
      if user = User.authenticate_by(params.permit(:email_address, :password))
        if user.admin?
          start_new_session_for user
          redirect_to root_url
        else
          redirect_to new_admin_session_path, alert: "Not authorized."
        end
      else
        redirect_to new_admin_session_path, alert: "Try another email address or password."
      end
    end

    def destroy
      terminate_session
      redirect_to new_admin_session_path, status: :see_other
    end
  end
end
