class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin_access

  def index
    @total_projects = Project.count
    @total_users = User.count
    @total_transactions = Transaction.count
    @total_in_escrow = Milestone.funded.sum(:amount_cents) + Milestone.completed.sum(:amount_cents)
    
    @recent_projects = Project.includes(:client, :developer).order(created_at: :desc).limit(5)
    @recent_transactions = Transaction.includes(:milestone).order(created_at: :desc).limit(5)
    @open_disputes = Dispute.open.includes(:milestone, :raised_by).limit(5)
    
    @user_stats = {
      clients: User.client.count,
      developers: User.developer.count,
      admins: User.admin.count
    }
    
    @project_stats = {
      draft: Project.draft.count,
      active: Project.active.count,
      completed: Project.completed.count,
      cancelled: Project.cancelled.count
    }
  end

  private

  def ensure_admin_access
    unless current_user.admin?
      redirect_to dashboard_path, alert: 'You do not have permission to access the admin area.'
    end
  end
end
