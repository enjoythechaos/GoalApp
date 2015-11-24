class GoalsController < ApplicationController
  before_action :require_logged_in!
  def index
    # if !signed_in?
    #   redirect_to new_session_url
    # # else
    # end
      @others_public_goals = Goal.all.where("user_id != #{current_user.id} AND visibility = 'Public'")
  end

  def new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id
    if @goal.save
      redirect_to goals_url
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :description, :visibility, :due_date, :status)
  end
end
