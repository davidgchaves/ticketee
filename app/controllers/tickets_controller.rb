class TicketsController < ApplicationController
  before_action :find_project
  before_action :find_ticket, only: [:show, :edit, :update, :destroy]

  def new
    @ticket = @project.tickets.build
  end

  def create
    @ticket = @project.tickets.build ticket_params
    if @ticket.save
      flash[:notice] = "Ticket has been created."
      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Ticket has not been created."
      render "new"
    end
  end

  def show
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

  private

    def find_project
      @project = Project.find params[:project_id]
    end

    def find_ticket
      @ticket = @project.tickets.find params[:id]
    end

    def ticket_params
      params.require(:ticket).permit :title, :description
    end
end
