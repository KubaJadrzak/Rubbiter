require "rails_helper"

RSpec.describe "Visiting the homepage", type: :system do
  it "shows the homepage" do
    visit root_path
    expect(page).to have_content("Welcome") # or whatever text is expected
  end
end
