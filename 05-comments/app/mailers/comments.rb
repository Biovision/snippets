class Comments < ApplicationMailer
  def entry_reply(comment)
    @comment = comment

    mail to: comment.commentable.user.email
  end
end
