class TicketsController < ApplicationController
  before_action :require_signin!
  before_action :find_project
  before_action :find_ticket, only: [:show, :edit, :update, :destroy, :watch]
  before_action :authorize_create!, only: [:new, :create]
  before_action :authorize_update!, only: [:edit, :update]
  before_action :authorize_delete!, only: [:destroy]

  def new
    @ticket = @project.tickets.build
    @ticket.assets.build
  end

  def create
    sanitize_params!
    @ticket = @project.tickets.build ticket_params
    @ticket.user = current_user
    if @ticket.save
      flash[:notice] = "Ticket has been created."
      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Ticket has not been created."
      render "new"
    end
  end

  def show
    @comment = @ticket.comments.build
    @states = State.all
  end

  def edit
  end

  def update
    if @ticket.update ticket_params
      flash[:notice] = "Ticket has been updated."
      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Ticket has not been updated."
      render action: "edit"
    end
  end

  def destroy
    @ticket.destroy
    flash[:notice] = "Ticket has been deleted."
    redirect_to @project
  end

  def search
    @tickets = @project.tickets.search params[:search]
    render "projects/show"
  end

  def watch
    toggle_watcher_status_for current_user
    redirect_to project_ticket_path(@ticket.project, @ticket)
  end

  private

    def find_project
      @project = Project.for(current_user).find params[:project_id]
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The project you were looking for could not be found."
      redirect_to root_path
    end

    def find_ticket
      @ticket = @project.tickets.find params[:id]
    end

    def ticket_params
      params.require(:ticket).permit :title, :description, :tag_names, assets_attributes: [:asset]
    end

    def authorize_create!
      if !current_user.admin? && cannot?(:"create tickets", @project)
        flash[:alert] = "You cannot create tickets on this project."
        redirect_to @project
      end
    end

    def authorize_update!
      if !current_user.admin? && cannot?(:"edit tickets", @project)
        flash[:alert] = "You cannot edit tickets on this project."
        redirect_to @project
      end
    end

    def authorize_delete!
      if !current_user.admin? && cannot?(:"delete tickets", @project)
        flash[:alert] = "You cannot delete tickets on this project."
        redirect_to @project
      end
    end

    def sanitize_params!
      if cannot?(:tag, @project)
        params[:ticket].delete :tag_names
      end
    end

    def toggle_watcher_status_for(user)
      if remove_from_watchers? user
        @ticket.remove_from_watchers user
        flash[:notice] = "You are no longer watching this ticket."
      else
        @ticket.add_to_watchers user
        flash[:notice] = "You are now watching this ticket."
      end
    end

    def remove_from_watchers?(user)
      @ticket.watchers.exists? user
    end
end
