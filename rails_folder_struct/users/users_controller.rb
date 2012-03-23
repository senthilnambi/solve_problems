class UsersController < ActionController::Metal
  include ActionController::Rendering

  def create
    user = User.find_by_github_id(params[:github_id])

    unless user
      User.create(params)
      render :text => 'success'
    else
      render :text => 'failed'
    end
  end
end
