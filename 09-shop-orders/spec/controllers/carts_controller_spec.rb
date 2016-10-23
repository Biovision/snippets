require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  context 'when order is set in session' do
    let!(:order) { create :order }

    before :each do
      expect(Order).to receive(:find_by).and_return(order)
    end

    describe 'get show' do
      before :each do
        get :show
      end

      it_behaves_like 'http_success'
    end

    describe 'get edit' do
      before :each do
        get :edit
      end

      it_behaves_like 'http_success'
    end

    describe 'patch update' do
      before :each do
        data = { name: 'a', email: 'b', phone: 'c', address: 'd', comment: 'e' }
        patch :update, params: { order: data }, session: { order_id: order.id }
      end

      it 'updates order' do
        order.reload
        expect(order.name).to eq('a')
        expect(order.email).to eq('b')
        expect(order.phone).to eq('c')
        expect(order.address).to eq('d')
        expect(order.comment).to eq('e')
      end

      it 'changes order state to "placed"' do
        order.reload
        expect(order).to be_placed
      end

      it 'removes order id from session' do
        expect(session[:order_id]).not_to be
      end

      it 'redirects to result page' do
        expect(response).to redirect_to(result_cart_path)
      end
    end

    describe 'delete destroy' do
      before :each do
        delete :destroy
      end

      it 'changes order status to "rejected"' do
        order.reload
        expect(order).to be_rejected
      end

      it 'removes order id from session' do
        expect(session[:order_id]).not_to be
      end

      it 'redirects to result page' do
        expect(response).to redirect_to(result_cart_path)
      end
    end

    describe 'get result' do
      before :each do
        get :result
      end

      it 'redirects to cart' do
        expect(response).to redirect_to(cart_path)
      end
    end
  end

  context 'when order is not set in session' do
    before :each do
      expect(Order).to receive(:find_by).and_return(nil)
    end

    describe 'get show' do
      before :each do
        get :show
      end

      it_behaves_like 'http_success'
    end

    describe 'get edit' do
      before :each do
        get :edit
      end

      it 'redirects to cart' do
        expect(response).to redirect_to(cart_path)
      end
    end

    describe 'patch update' do
      before :each do
        patch :update, params: { order: { name: 'nope' } }
      end

      it 'redirects to cart' do
        expect(response).to redirect_to(cart_path)
      end
    end

    describe 'delete destroy' do
      before :each do
        delete :destroy
      end

      it 'redirects to cart' do
        expect(response).to redirect_to(cart_path)
      end
    end

    describe 'get result' do
      before :each do
        get :result
      end

      it_behaves_like 'http_success'
    end
  end
end
