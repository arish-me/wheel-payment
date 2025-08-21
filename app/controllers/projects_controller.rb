class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :ensure_client_access, only: [:new, :create, :edit, :update, :destroy]

  def index
    if current_user.client?
      @projects = current_user.client_projects.includes(:milestones, :developer)
    elsif current_user.developer?
      @projects = current_user.developer_projects.includes(:milestones, :client)
    else
      @projects = Project.includes(:milestones, :client, :developer)
    end
  end

  def show
    @milestones = @project.milestones.order(:created_at)
    @new_milestone = @project.milestones.build
  end

  def new
    @project = current_user.client_projects.build
  end

  def create
    @project = current_user.client_projects.build(project_params)
    
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :developer_id, :status)
  end

  def ensure_client_access
    unless current_user.client?
      redirect_to dashboard_path, alert: 'Only clients can manage projects.'
    end
  end
end
