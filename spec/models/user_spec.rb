require "rails_helper"

RSpec.describe User, type: :model do
  context "with attribute validations" do
    it "is valid with valid username, email, password and password_confirmation" do
      user = create(:user)
      expect(user).to be_valid
    end

    it "is invalid with no username" do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with no email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with invalid email" do
      user = build(:user, email: "sunflower")
      expect(user).not_to be_valid
    end

    it "is invalid with no password" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with password shorter then 6 characters" do
      user = build(:user, password: "sun")
      expect(user).not_to be_valid
    end

    it "is invalid when password doesn't match password confirmation" do
      user = build(:user, password: "password", password_confirmation: "not_password")
      expect(user).not_to be_valid
    end
  end

  context "with uniqueness validation" do
    it "is valid when username and email are unique" do
      create(:user)
      user = build(:user)
      expect(user).to be_valid
    end

    it "is invalid when username is not unique" do
      user1 = create(:user)
      user2 = build(:user, username: user1.username)
      expect(user2).not_to be_valid
    end

    it "is invalid when email is not unique" do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).not_to be_valid
    end
  end
end
