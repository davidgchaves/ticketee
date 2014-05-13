class TagsController < ApplicationController
  def remove
    @ticket = Ticket.find params[:ticket_id]
    remove_tag if authorized_to_remove_tag?
  end

  private

    def authorized_to_remove_tag?
      can?(:tag, @ticket.project) || current_user.admin?
    end

    def remove_tag
      @tag = Tag.find params[:id]
      @ticket.tags -= [@tag]
      @ticket.save
    end
end
