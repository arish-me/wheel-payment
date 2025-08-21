class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    
    if @user.client?
      @client_projects = @user.client_projects.includes(:milestones, :developer)
      @total_in_escrow = @user.client_projects.joins(:milestones).where(milestones: { status: [:funded, :completed] }).sum('milestones.amount_cents')
    elsif @user.developer?
      @developer_projects = @user.developer_projects.includes(:milestones, :client)
      @total_earned = @user.developer_projects.joins(:milestones).where(milestones: { status: :released }).sum('milestones.amount_cents')
    elsif @user.admin?
      @total_projects = Project.count
      @total_transactions = Transaction.completed.count
      @total_in_escrow = Milestone.funded.sum(:amount_cents) + Milestone.completed.sum(:amount_cents)
    end
  end
end
