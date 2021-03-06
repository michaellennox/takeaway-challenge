require 'takeaway'

describe Takeaway do
  subject(:takeaway) { described_class.new(menu: menu, order_klass: order_klass, checkout: checkout) }
  let(:menu) { double(:menu, dishes: menu_contents, includes?: true) }
  let(:menu_contents) { {burger: 1.88, beef: 2.34, fries: 1.10} }
  let(:order_klass) { double(:order, new: order) }
  let(:order) { double(:order, order_item: nil, list: nil) }
  let(:checkout) { double(:checkout) }

  describe '#read_menu' do
    it 'should return what is present on the menu' do
      expect(takeaway.read_menu).to include menu_contents
    end
  end

  describe '#order' do
    it 'should tell current_order to add an item' do
      expect(order).to receive(:order_item).with(:burger, 2)
      takeaway.order(:burger, 2)
    end

    it 'should fail if the item requested is not in the menu' do
      allow(menu).to receive(:includes?).and_return(false)
      expect{takeaway.order(:lamb, 3)}.to raise_error "You cannot buy lamb here"
    end

    it 'should default the number ordered to 1 if no argument passed' do
      expect(order).to receive(:order_item).with(:beef, 1)
      takeaway.order(:beef)
    end
  end

  describe '#basket_summary' do
    it 'should send a call to checkout with order and price lists' do
      expect(checkout).to receive(:sum_each).with(order.list, menu.dishes)
      takeaway.basket_summary
    end
  end

  describe '#basket_total' do
    it 'should send a call to checkout with order and price lists' do
      expect(checkout).to receive(:sum_total).with(order.list, menu.dishes)
      takeaway.basket_total
    end

    it 'should convert what is returned by checkout to a string' do
      allow(checkout).to receive(:sum_total).and_return(5.59)
      expect(takeaway.basket_total).to eq "£5.59"
    end
  end

  describe '#basket_checkout' do
    it 'should send a call to pay everything up' do
      expect(checkout).to receive(:finalise_payment).with(5.59, order.list, menu.dishes)
      takeaway.basket_checkout(5.59)
    end
  end

end
