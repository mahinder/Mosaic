class UserMailer < ActionMailer::Base
  def registration_confirmation(user,subject,body)
    recipients  user.email
    from        "office@ezzie.in"
    subject     subject
    body        body
  end

end
