class ApplicationMailer < ActionMailer::Base
  layout "email"
  self.default :from => "\"moziy.com\" <moziy@moziy.com>"
end
