class CustomDeviseMailer < Devise::Mailer
  # add all other needed helper methods


  def confirmation_instructions(record, token, opts={})
    # customize logic here if needed
    super
  end
end