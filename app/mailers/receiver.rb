class Receiver < ActionMailer::Base
  default from: "from@example.com"

  def self.parse(received_email)
    comment_text = get_comment_text_from received_email

    create_comment_from comment_text, received_email if valid_reply? comment_text
  end

  private

    def self.get_comment_text_from(email)
      reply_separator = /(.*?)\s?== ADD YOUR REPLY ABOVE THIS LINE ==/m
      reply_separator.match email.body.to_s
    end

    def self.valid_reply?(comment_text)
      comment_text
    end

    def self.create_comment_from(comment_text, email)
      ticket = get_ticket_for_this email
      user = get_user_for_this email

      ticket.comments.create({ text: comment_text[1].strip, user: user })
    end

    def self.get_ticket_for_this(email)
      _, project_id, ticket_id = get_project_and_ticket_ids_from email
      project = Project.find project_id
      project.tickets.find ticket_id
    end

    def self.get_project_and_ticket_ids_from(email)
      email.to.first.split("@")[0].split "+"
    end

    def self.get_user_for_this(email)
      User.find_by_email email.from[0]
    end
end
