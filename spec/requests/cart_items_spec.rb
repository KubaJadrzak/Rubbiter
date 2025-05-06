require "rails_helper"

RSpec.describe "CartItemsController", type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  describe "POST add_to_cart/:product_id" do
    context "when user is logged in" do
      before do
        sign_in user
      end
      it "adds product to cart and shows success notice message" do
        get products_path
        token = controller.send(:form_authenticity_token)

        post add_to_cart_path(product.id),
             params: {
               authenticity_token: token,
             }

        expect(CartItem.count).to eq(1)
        expect(response).to redirect_to(products_path)
        follow_redirect!
        expect(response.body).to include("#{product.title} added to cart!")
      end
    end
    context "when user is not logged in" do
      it "redirect to sign in page and shows error message" do
        get products_path
        token = controller.send(:form_authenticity_token)

        post add_to_cart_path(product.id),
             params: {
               authenticity_token: token,
             }

        expect(response).to redirect_to(new_user_session_path)
        follow_redirect!
        expect(response.body).to include("You need to sign in or sign up before continuing.")
      end
    end
    describe "DELETE /cart_items/:id" do
      context "when CartItem is removed" do
        let(:cart_item) { create(:cart_item, cart: user.cart, product: product, quantity: 1, price: product.price) }
        before do
          sign_in user
        end
        it "shows item removed from cart message" do
          expect(CartItem.count).to eq(0)
          get cart_path(user.cart)
          token = controller.send(:form_authenticity_token)

          delete cart_item_path(cart_item),
                 params: {
                   authenticity_token: token,
                 }
          expect(response).to redirect_to(cart_path)
          expect(CartItem.count).to eq(0)
          follow_redirect!
          expect(response.body).to include("Item removed from cart.")
        end
      end
    end
  end
end
