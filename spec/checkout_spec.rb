require 'checkout'

describe Checkout do
  subject(:checkout) { described_class.new }
  let(:order) { {shrimp: 1, burger: 2} }
  let(:prices) { {burger: 2.44, shrimp: 2.33} }

  describe '#sum_basket' do
    it 'should sum the basket from two lists, the order and price' do
      summary = '1x shrimp = £2.33, 2x burger = £4.88'
      expect(checkout.sum_basket(order, prices)).to eq summary
    end
  end

end
