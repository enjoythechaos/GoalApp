class GoalsController < ApplicationController
  before_action :require_logged_in!
  before_action :ensure_visitor_is_goal_creator, only: [:edit, :update, :delete]

  def index
      @others_public_goals = Goal.all.where("user_id != #{current_user.id} AND visibility = 'Public'")
  end

  def new
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
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

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    flash[:notice] = ["Goal successfully deleted!"]
    redirect_to goals_url
  end

  def ensure_visitor_is_goal_creator
    @goal = Goal.find(params[:id])
    if @goal.user_id != current_user.id
      redirect_to goal_url(@goal)
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :description, :visibility, :due_date, :status)
  end
end
