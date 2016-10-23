require 'rails_helper'

RSpec.describe Api::CartController, type: :controller do
  let(:item) { create :item }

  context 'when order is set' do
    let!(:order) { create :order }

    before :each do
      allow(Order).to receive(:find_by).and_return(order)
    end

    shared_examples 'order_finder' do
      it 'finds order by id in session' do
        expect(Order).to have_received(:find_by)
      end
    end

    describe 'get show' do
      before :each do
        get :show
      end

      it_behaves_like 'order_finder'
      it_behaves_like 'http_success'
    end

    describe 'post add_item' do
      before :each do
        allow(order).to receive(:add_item)
        post :add_item, params: { item_id: item.id, quantity: 1 }
      end

      it_behaves_like 'order_finder'
      it_behaves_like 'http_success'

      it 'adds item to order' do
        expect(order).to have_received(:add_item)
      end
    end

    describe 'delete remove_item' do
      before :each do
        allow(order).to receive(:remove_item)
        delete :remove_item, params: { id: item.id }
      end

      it_behaves_like 'order_finder'
      it_behaves_like 'http_success'

      it 'removes item from order' do
        expect(order).to have_received(:remove_item)
      end
    end
  end

  context 'when order is not set' do
    before :each do
      allow(Order).to receive(:find_by).and_return(nil)
    end

    describe 'get show' do
      let(:action) { -> { get :show } }

      it 'does not create new order' do
        expect(action).not_to change(Order, :count)
      end

      it 'responds with HTTP status 201' do
        action.call
        expect(response).to have_http_status(:no_content)
      end
    end

    describe 'post items' do
      let(:action) { -> { post :add_item, params: { item_id: item.id } } }

      it 'creates new order' do
        expect(action).to change(Order, :count).by(1)
      end

      it 'adds item to order' do
        expect_any_instance_of(Order).to receive(:add_item)
        action.call
      end

      it 'responds with HTTP status 200' do
        action.call
        expect(response).to be_success
      end
    end

    describe 'delete item' do
      let(:action) { -> { delete :remove_item, params: { id: item.id } } }

      it 'does not create new order' do
        expect(action).not_to change(Order, :count)
      end

      it 'responds with HTTP status 201' do
        action.call
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
