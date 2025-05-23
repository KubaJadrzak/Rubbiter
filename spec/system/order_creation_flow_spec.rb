require "rails_helper"

RSpec.describe "Order Creation Flow", type: :system do
  let(:user) { create(:user) }
  let!(:product) { create(:product) }

  describe "when user is logged in" do
    before do
      sign_in user
    end

    it "allows user to create an order, redirects to Espago payment website and confirms order information (order_number, price, payment_id)" do
      visit root_path
      expect(page).to have_content("Trending Users")
      click_button "PURCHASE MERCHANDISE"
      expect(page).to have_content("Add to Cart")
      click_button "Add to Cart"
      expect(page).to have_text("added to cart!")
      expect(page).to_not have_text("added to cart!", wait: 10)
      find('img[alt="Cart"]').click

      expect(page).to have_content("Your Cart")
      expect(page).to have_selector(".cart-item", count: 1)

      click_link "Place Order"

      expect(page).to have_content("Email")

      fill_in "Country", with: "France"
      fill_in "Street Address", with: "123 Rails Ave"
      fill_in "Postal Code", with: "75001"

      click_button "Purchase"
      order = Order.last

      expect(current_url).to match(/secure_web_page/)

      expect(page).to have_content(order.order_number)
      expect(page).to have_content(order.total_price.to_s)
      expect(page).to have_content(order.payment_id)
    end
  end

  describe "when user is not logged in" do
    it "redirects user to sign in page after clicking trying to add product to cart" do
      visit root_path
      expect(page).to have_content("Trending Users")
      click_button "PURCHASE MERCHANDISE"
      expect(page).to have_content("Add to Cart")
      click_button "Add to Cart"

      expect(page).to have_content("Sign in as Example User")
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end
end
