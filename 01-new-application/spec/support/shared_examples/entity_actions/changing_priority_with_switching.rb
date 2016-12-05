require 'rails_helper'

RSpec.shared_examples_for 'changing_priority_with_switching' do
  context 'increasing' do
    let(:action) { -> { entity_b.change_priority(1) } }

    context 'when entity with new priority exists' do
      it 'increases priority for current entity' do
        expect(action).to change(entity_b, :priority).from(3).to(4)
      end

      it 'decreases priority for other entity' do
        action.call
        entity_c.reload
        expect(entity_c.priority).to eq(3)
      end

      it 'returns ordered hash' do
        expected_hash = {
            entity_a.id => 2, entity_c.id => 3, entity_b.id => 4
        }
        expect(action.call).to eq(expected_hash)
      end
    end

    context 'when entity with new priority does not exist' do
      before :each do
        entity_c.update! priority: 5
      end

      it 'increases priority for current entity' do
        expect(action).to change(entity_b, :priority).from(3).to(4)
      end

      it 'does not change priority for other entity' do
        expect(action).not_to change(entity_c, :priority)
      end

      it 'returns ordered hash' do
        expected_hash = {
            entity_a.id => 2, entity_b.id => 4, entity_c.id => 5
        }
        expect(action.call).to eq(expected_hash)
      end
    end
  end

  context 'decreasing' do
    let(:action) { -> { entity_b.change_priority(-1) } }

    context 'when entity with new priority exists' do
      it 'decreases priority for current entity' do
        expect(action).to change(entity_b, :priority).from(3).to(2)
      end

      it 'increases priority for other entity' do
        action.call
        entity_a.reload
        expect(entity_a.priority).to eq(3)
      end

      it 'returns ordered hash' do
        expected_hash = {
            entity_b.id => 2, entity_a.id => 3, entity_c.id => 4
        }
        expect(action.call).to eq(expected_hash)
      end
    end

    context 'when entity with new priority does not exist' do
      before :each do
        entity_a.update! priority: 1
      end

      it 'decreases priority for current entity' do
        expect(action).to change(entity_b, :priority).from(3).to(2)
      end

      it 'does not change priority for other entity' do
        expect(action).not_to change(entity_a, :priority)
      end

      it 'returns ordered hash' do
        expected_hash = {
            entity_a.id => 1, entity_b.id => 2, entity_c.id => 4
        }
        expect(action.call).to eq(expected_hash)
      end
    end
  end
end
