class CommentsController < ApplicationController
  before_action :require_signin!

  def create
    @ticket = Ticket.find params[:ticket_id]
    prevent_unauthorize_hacking_of_state_id

    @comment = @ticket.comments.build comment_params
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Comment has been created."
      redirect_to [@ticket.project, @ticket]
    else
      @states = State.all
      flash[:alert] = "Comment has not been created."
      render template: "tickets/show"
    end
  end

  private

    def comment_params
      params.require(:comment).permit :text, :state_id, :tag_names
    end

    def prevent_unauthorize_hacking_of_state_id
      if cannot?(:"change states", @ticket.project)
        params[:comment].delete :state_id
      end
    end
end
