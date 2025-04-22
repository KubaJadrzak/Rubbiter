require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /user" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end
    it "returns a successful response" do
      get user_path
      expect(response).to have_http_status(:ok)
    end
  end
end
