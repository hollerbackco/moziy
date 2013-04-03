require 'spec_helper'

describe Manage::ContactsController do

  describe "GET 'lookup'" do
    it "returns http success" do
      get 'lookup'
      response.should be_success
    end
  end

end
