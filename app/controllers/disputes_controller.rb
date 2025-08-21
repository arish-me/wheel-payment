class DisputesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_milestone
  before_action :ensure_participant_access

  def create
    @dispute = @milestone.disputes.build(dispute_params)
    @dispute.raised_by = current_user
    @dispute.status = :open

    if @dispute.save
      redirect_to @project, notice: 'Dispute was successfully raised.'
    else
      @milestones = @project.milestones.order(:created_at)
      @new_milestone = @project.milestones.build
      render 'projects/show', status: :unprocessable_content
    end
  end

  def update
    @dispute = @milestone.disputes.find(params[:id])
    
    if @dispute.update(dispute_params)
      redirect_to @project, notice: 'Dispute was successfully updated.'
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

  def dispute_params
    params.require(:dispute).permit(:reason)
  end

  def ensure_participant_access
    unless @project.client == current_user || @project.developer == current_user
      redirect_to dashboard_path, alert: 'You do not have permission to perform this action.'
    end
  end
end
