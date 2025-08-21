class MilestonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_milestone, only: [:update, :destroy, :fund, :complete, :release, :refund]
  before_action :ensure_client_access, only: [:create, :update, :destroy, :fund, :release, :refund]
  before_action :ensure_developer_access, only: [:complete]

  def create
    @milestone = @project.milestones.build(milestone_params)
    @milestone.status = :pending  # Set default status
    if @milestone.save
      redirect_to @project, notice: 'Milestone was successfully created.'
    else
      @milestones = @project.milestones.order(:created_at)
      @new_milestone = @milestone  # Use the failed milestone to preserve form data and show errors
      render 'projects/show', status: :unprocessable_content
    end
  end

  def update
    if @milestone.update(milestone_params)
      redirect_to @project, notice: 'Milestone was successfully updated.'
    else
      @milestones = @project.milestones.order(:created_at)
      @new_milestone = @project.milestones.build
      render 'projects/show', status: :unprocessable_content
    end
  end

  def destroy
    @milestone.destroy
    redirect_to @project, notice: 'Milestone was successfully deleted.'
  end

  def fund
    if @milestone.can_be_funded?
      # Redirect to Stripe Checkout instead of direct funding
      redirect_to payments_create_checkout_session_path(milestone_id: @milestone.id)
    else
      redirect_to @project, alert: 'Milestone cannot be funded at this time.'
    end
  end

  def complete
    if @milestone.can_be_completed?
      @milestone.update!(status: :completed)
      redirect_to @project, notice: 'Milestone was marked as completed.'
    else
      redirect_to @project, alert: 'Milestone cannot be completed at this time.'
    end
  end

  def release
    if @milestone.can_be_released?
      begin
        stripe_service = StripeService.new
        result = stripe_service.release_milestone(@milestone)

        if result
          @milestone.update!(status: :released)
          redirect_to @project, notice: 'Milestone was successfully released to developer.'
        else
          redirect_to @project, alert: 'Failed to release milestone. Please try again.'
        end
      rescue Stripe::StripeError => e
        Rails.logger.error "Stripe error during release: #{e.message}"
        redirect_to @project, alert: 'Payment processing error. Please try again.'
      rescue => e
        Rails.logger.error "Release error: #{e.message}"
        redirect_to @project, alert: 'An error occurred while releasing the milestone.'
      end
    else
      redirect_to @project, alert: 'Milestone cannot be released at this time.'
    end
  end

  def refund
    if @milestone.can_be_refunded?
      begin
        stripe_service = StripeService.new
        result = stripe_service.refund_milestone(@milestone)

        if result
          @milestone.update!(status: :refunded)
          redirect_to @project, notice: 'Milestone was successfully refunded.'
        else
          redirect_to @project, alert: 'Failed to refund milestone. Please try again.'
        end
      rescue Stripe::StripeError => e
        Rails.logger.error "Stripe error during refund: #{e.message}"
        redirect_to @project, alert: 'Payment processing error. Please try again.'
      rescue => e
        Rails.logger.error "Refund error: #{e.message}"
        redirect_to @project, alert: 'An error occurred while refunding the milestone.'
      end
    else
      redirect_to @project, alert: 'Milestone cannot be refunded at this time.'
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_milestone
    @milestone = @project.milestones.find(params[:id])
  end

  def milestone_params
    params.require(:milestone).permit(:title, :description, :amount_cents, :currency)
  end

  def ensure_client_access
    unless current_user.client? && @project.client == current_user
      redirect_to dashboard_path, alert: 'You do not have permission to perform this action.'
    end
  end

  def ensure_developer_access
    unless current_user.developer? && @project.developer == current_user
      redirect_to dashboard_path, alert: 'You do not have permission to perform this action.'
    end
  end
end
