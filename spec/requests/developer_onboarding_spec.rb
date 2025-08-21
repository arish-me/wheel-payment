require 'rails_helper'

RSpec.describe "DeveloperOnboardings", type: :request do
  describe "GET /stripe_connect" do
    it "returns http success" do
      get "/developer_onboarding/stripe_connect"
      expect(response).to have_http_status(:success)
    end
  end

end
