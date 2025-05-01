require "rails_helper"

RSpec.describe "Payment Flow", type: :system do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, :with_items, user: user, items_count: 2) }

  before do
    sign_in user
  end

  def start_checkout_flow
    visit cart_path(cart)

    expect(page).to have_content("Your Cart")
    expect(page).to have_selector(".cart-item", count: 2)

    click_link "Place Order"
    expect(current_path).to eq(new_order_path)

    fill_in "Country", with: "France"
    fill_in "Street Address", with: "123 Rails Ave"
    fill_in "Postal Code", with: "75001"
    click_button "Purchase"
    Order.first
  end

  def mock_back_request_response(order, state)
    valid_payload = {
      "id" => order.payment_id,
      "state" => state,
    }

    headers = {
      "Authorization" => "Basic #{Base64.strict_encode64("#{Rails.application.credentials.dig(:espago, :app_id)}:#{Rails.application.credentials.dig(:espago, :password)}")}",
      "Content-Type" => "application/json",
    }

    post "/back_request", params: valid_payload.to_json, headers: headers
  end

  context "when payment is successful" do
    let!(:order) { start_checkout_flow }

    it "redirects to Espago payment website and confirms order information (order_number, price, payment_id)" do
      expect(current_url).to match(/secure_web_page/)

      expect(page).to have_content(order.order_number)
      expect(page).to have_content(order.total_price.to_s)
      expect(page).to have_content(order.payment_id)
    end

    it "redirects to order show page and shows payment success notice after successful payment (after redirect from Espago)" do
      expect(page).to have_content(order.order_number)

      fill_in "transaction[credit_card_attributes][first_name]", with: "John"
      fill_in "transaction[credit_card_attributes][last_name]", with: "Doe"
      fill_in "transaction[credit_card_attributes][number]", with: "4012000000020006"
      fill_in "transaction[credit_card_attributes][month]", with: "01"
      fill_in "transaction[credit_card_attributes][year]", with: "28"
      fill_in "transaction[credit_card_attributes][verification_value]", with: "123"
      find("#submit_payment").click
      expect(page).to have_css("#challenge_iframe", visible: true)
      within_frame("challenge_iframe") do
        sleep 5
        expect(page).to have_content("3D-Secure 2 Payment - simulation")
        expect(page).to have_css("#confirm-btn", visible: true)
        page.execute_script("document.querySelector('#confirm-btn').click()")
      end
      sleep 5
      expect(page).to have_content("Payment successful!")
      click_button "Back to shop"

      expect(current_path).to eq(order_path(order))
      expect(page).to have_content("Payment successful!")
    end
    it "updates order payment status to executed and order status to Preparing for Shipment based on back_request and shows payment status Paid to user" do
      mock_back_request_response(order, "executed")
      order.reload
      expect(order.payment_status).to eq("executed")
      expect(order.status).to eq("Preparing for Shipment")

      visit order_path(order)
      expect(page).to have_content("Preparing for Shipment")
      expect(page).to have_content("Paid")
    end
  end

  context "when payment is rejected" do
    let!(:order) { start_checkout_flow }

    it "redirects to Espago payment website and confirms order information (order_number, price, payment_id)" do
      expect(current_url).to match(/secure_web_page/)

      expect(page).to have_content(order.order_number)
      expect(page).to have_content(order.total_price.to_s)
      expect(page).to have_content(order.payment_id)
    end

    it "redirects to order show page and shows payment failure notice after unsuccessful payment (after redirect from Espago)" do
      expect(current_url).to match(/secure_web_page/)

      fill_in "transaction[credit_card_attributes][first_name]", with: "John"
      fill_in "transaction[credit_card_attributes][last_name]", with: "Doe"
      fill_in "transaction[credit_card_attributes][number]", with: "4012000000020006"
      fill_in "transaction[credit_card_attributes][month]", with: "12"
      fill_in "transaction[credit_card_attributes][year]", with: "28"
      fill_in "transaction[credit_card_attributes][verification_value]", with: "683"
      find("#submit_payment").click
      expect(page).to have_css("#challenge_iframe", visible: true)
      within_frame("challenge_iframe") do
        sleep 5
        expect(page).to have_content("3D-Secure 2 Payment - simulation")
        expect(page).to have_css("#confirm-btn", visible: true)
        page.execute_script("document.querySelector('#confirm-btn').click()")
      end
      sleep 5
      expect(page).to have_content("Payment declined!")
      click_button "Back to shop"

      expect(current_path).to eq(order_path(order))
      expect(page).to have_content("Payment failed!")
    end

    it "updates order payment status to rejected and order status to Payment Failed based on back_request and shows payment status Failed to user" do
      mock_back_request_response(order, "rejected")
      order.reload

      expect(order.payment_status).to eq("rejected")
      expect(order.status).to eq("Payment Failed")

      visit order_path(order)

      expect(page).to have_content("Failed")
    end
  end

  context "when payment is abandoned via cancel form option on Espago website" do
    let!(:order) { start_checkout_flow }

    it "redirects to Espago payment website and confirms order information (order_number, price, payment_id)" do
      expect(current_url).to match(/secure_web_page/)

      expect(page).to have_content(order.order_number)
      expect(page).to have_content(order.total_price.to_s)
      expect(page).to have_content(order.payment_id)
    end

    it "redirects to order show page and shows payment failure notice after user resignes from payment with payment status Processing and status Created" do
      expect(current_url).to match(/secure_web_page/)
      accept_confirm do
        click_link "❮ Cancel"
      end
      expect(page).to have_content("Back to shop")
      click_button("Back to shop")

      expect(page).to have_content("Payment failed!")
    end

    it "updates order payment status to resign and order status to Payment Failed based on back_request and shows payment status Failed to user" do
      mock_back_request_response(order, "resigned")
      order.reload

      expect(order.payment_status).to eq("resigned")
      expect(order.status).to eq("Payment Resigned")

      visit order_path(order)

      expect(page).to have_content("Resigned")
      expect(page).to have_content("Payment Resigned")
    end
  end
  context "when payment is abandoned by leaving Espago website (for example by closing browser or changing URL)" do
    let!(:order) { start_checkout_flow }

    it "redirects to Espago payment website and confirms order information (order_number, price, payment_id)" do
      expect(current_url).to match(/secure_web_page/)

      expect(page).to have_content(order.order_number)
      expect(page).to have_content(order.total_price.to_s)
      expect(page).to have_content(order.payment_id)
    end

    it "order show page displays payment status as Processing and status as created" do
      expect(current_url).to match(/secure_web_page/)

      visit root_path
      visit order_path(order)

      expect(page).to have_content("Created")
      expect(page).to have_content("Processing")
    end
    # this will not happen while using the website since Espago sandbox doesn't issue back_responses in such scenarios
    it "updates order payment status to resign and order status to Payment Failed based on back_request and shows payment status Failed to user*" do
      mock_back_request_response(order, "resigned")
      order.reload

      expect(order.payment_status).to eq("resigned")
      expect(order.status).to eq("Payment Resigned")

      visit order_path(order)

      expect(page).to have_content("Resigned")
      expect(page).to have_content("Payment Resigned")
    end
  end
end
