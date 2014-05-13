class CommentsController < ApplicationController
  before_action :require_signin!

  def create
    @ticket = Ticket.find params[:ticket_id]
    sanitize_params!

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

    def sanitize_params!
      if cannot?(:"change states", @ticket.project)
        params[:comment].delete :state_id
      end
      if cannot?(:tag, @ticket.project)
        params[:comment].delete :tag_names
      end
    end
end
