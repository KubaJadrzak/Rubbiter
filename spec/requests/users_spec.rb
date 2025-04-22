require "rails_helper"

RSpec.describe "User account creation management", type: :request do
  it "creates a User with valid attributes and redirects to root page" do
    get "/users/sign_up"
    expect(response).to render_template("devise/registrations/new")

    post "/users", params: {
                     user: {
                       username: "test",
                       email: "test@test.test",
                       password: "password",
                       password_confirmation: "password",
                     },
                   }
    expect(User.count).to eq(1)
    expect(response).to redirect_to("/")
    follow_redirect!
    expect(response).to render_template("rubits/index")
  end

  it "does not create a User with invalid attributes and re-renders sign up page" do
    get "/users/sign_up"
    expect(response).to render_template("devise/registrations/new")

    post "/users", params: {
                     user: {
                       username: "test",
                       email: "test@test.test",
                       password: "password1",
                       password_confirmation: "password2",
                     },
                   }
    expect(User.count).to eq(0)
    expect(response).to render_template("devise/registrations/new")
  end
end

RSpec.describe "User session management", type: :request do
  let(:user) { create(:user) }
  before do
    sign_in user
  end

  it "displays user show page when user is logged in" do
    get "/user"
    expect(response).to render_template("users/show")
  end

  it "redirects to sign_in page when user is not logged in" do
    sign_out user
    get "/user"
    expect(response).to redirect_to(new_user_session_path)
  end

  it "signs out a User and redirect to root page" do
    get "/user"
    expect(response).to render_template("users/show")

    delete "/users/sign_out"
    expect(response).to redirect_to("/")
    follow_redirect!
    expect(response).to render_template("rubits/index")
  end
end
