require 'rails_helper'

RSpec.describe "Milestones", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/milestones/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/milestones/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/milestones/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /fund" do
    it "returns http success" do
      get "/milestones/fund"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /complete" do
    it "returns http success" do
      get "/milestones/complete"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /release" do
    it "returns http success" do
      get "/milestones/release"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /refund" do
    it "returns http success" do
      get "/milestones/refund"
      expect(response).to have_http_status(:success)
    end
  end

end
