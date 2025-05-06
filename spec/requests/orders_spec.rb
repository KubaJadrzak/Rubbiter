require "rails_helper"

RSpec.describe "OrdersController", type: :request do
  let(:user) { create(:user) }
  let(:cart) { user.cart }
  let!(:product) { create(:product) }

  before do
    sign_in user
    create(:cart_item, cart: cart, product: product, quantity: 1, price: product.price)
  end

  describe "GET /orders/new" do
    context "when cart has items" do
      it "allows access to the new order page" do
        get new_order_path
        expect(response.body).to include("Purchase")
      end
    end

    context "when cart is empty" do
      before do
        cart.cart_items.destroy_all
      end

      it "redirects to the cart page" do
        get new_order_path
        expect(response).to redirect_to(cart_path)
      end
    end
  end

  describe "POST /orders" do
    context "when cart has items" do
      it "creates a new order" do
        get new_order_path
        token = controller.send(:form_authenticity_token)

        post orders_path,
             params: {
               order: {
                 country: "France",
                 street: "123 Rails Ave",
                 postal_code: "75001",
               },
             },
             headers: {
               "X-CSRF-Token" => token,
             }

        expect(Order.count).to eq(1)
        expect(Order.last.user).to eq(user)
        expect(Order.last.shipping_address).to eq("France, 123 Rails Ave, 75001")
      end
    end

    context "when cart is empty" do
      before do
        cart.cart_items.destroy_all
      end

      it "redirects to the cart page" do
        get new_order_path
        token = controller.send(:form_authenticity_token)

        post orders_path,
             params: {
               order: {
                 country: "France",
                 street: "123 Rails Ave",
                 postal_code: "75001",
               },
             },
             headers: {
               "X-CSRF-Token" => token,
             }
      end
    end
  end

  describe "GET /orders" do
    it "shows a list of orders" do
      create(:order, user: user, status: "Created")
      create(:order, user: user, status: "Processing")

      get orders_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Created")
      expect(response.body).to include("Processing")
    end
  end

  describe "GET /orders/:id" do
    let!(:order) { create(:order, user: user, status: "Created") }

    it "shows the order details" do
      get order_path(order)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Created")
      expect(response.body).to include("Processing")
    end
  end
end
