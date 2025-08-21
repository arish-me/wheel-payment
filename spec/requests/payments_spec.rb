require 'rails_helper'

RSpec.describe "Payments", type: :request do
  describe "GET /create_checkout_session" do
    it "returns http success" do
      get "/payments/create_checkout_session"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /success" do
    it "returns http success" do
      get "/payments/success"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /cancel" do
    it "returns http success" do
      get "/payments/cancel"
      expect(response).to have_http_status(:success)
    end
  end

end
