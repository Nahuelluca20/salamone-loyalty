module Admin
  class UsersController < Admin::BaseController
    def search
      q = params[:q].to_s.strip.downcase
      @users = if q.length < 2
        User.none
      else
        User.customers.where("email_address LIKE ?", "#{q}%").limit(8)
      end
      render partial: "admin/users/results", locals: { users: @users }
    end
  end
end
