class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_milestone
  before_action :ensure_client_access

  def create
    @review = @milestone.build_review(review_params)
    @review.reviewer = current_user
    @review.reviewed = @milestone.developer

    if @review.save
      redirect_to @project, notice: 'Review was successfully submitted.'
    else
      @milestones = @project.milestones.order(:created_at)
      @new_milestone = @project.milestones.build
      render 'projects/show', status: :unprocessable_content
    end
  end

  def update
    @review = @milestone.review
    
    if @review.update(review_params)
      redirect_to @project, notice: 'Review was successfully updated.'
    else
      @milestones = @project.milestones.order(:created_at)
      @new_milestone = @project.milestones.build
      render 'projects/show', status: :unprocessable_content
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_milestone
    @milestone = @project.milestones.find(params[:milestone_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def ensure_client_access
    unless @project.client == current_user
      redirect_to dashboard_path, alert: 'Only the client can review milestones.'
    end
  end
end
