describe 'User Stories' do
  let(:takeaway) { Takeaway.new(menu: menu) }
  let(:menu) { Menu.new }

  # Below stories were added by myself to remove the need to hard-code in a menu

  # As a restaurant owner,
  # So I can manage the items on my menu
  # I want to be able to add new items to it
  it 'to manage items on my menu, I want to be able to add new items' do
    menu.add_item(:shrimp, 1.88)
    expect(menu.dishes).to include(shrimp: 1.88)
  end

  # As a restaurant owner,
  # So I can manage what happens when items run out
  # I want to be able to remove existing items on it
  it 'to manage out of stock, I want to be able to remove existing items' do
    menu.add_item(:burger, 2.44)
    menu.remove_item(:burger)
    expect(menu.dishes).to be_empty
  end

  context 'after the restaurant owner has populated their menu' do
    before(:example) do
      menu.add_item(:burger, 2.44)
      menu.add_item(:shrimp, 1.88)
      menu.add_item(:fries, 1.22)
      menu.add_item(:beef, 4.22)
    end

    # As a customer
    # So that I can check if I want to order something
    # I would like to see a list of dishes with prices
    it 'to check what is in offer, I would like to see a list of items' do
      expect(takeaway.read_menu).to include(burger: 2.44, shrimp: 1.88)
    end

    # As a customer
    # So that I can order the meal I want
    # I would like to be able to select some number of several available dishes
    it 'so I can order my meal, I would like to log items to my order' do
      takeaway.order(:burger, 4)
      takeaway.order(:shrimp, 2)
      expect(takeaway.current_order.list).to include(burger: 4, shrimp: 2)
    end

    it 'I would like to be stopped from ordering items not on menu' do
      expect{takeaway.order(:cat, 3)}.to raise_error "You cannot buy cat here"
    end

    # As a customer,
    # So that I can verify that my order is correct,
    # I would like to check that the total I have been given
    # matches the sum of the various dishes in my order
    context 'after customer\'s order is complete' do
      before(:example) do
        takeaway.order(:burger, 4)
        takeaway.order(:shrimp, 2)
      end

      it 'to verify the order is correct, I should see each dishes sum' do
        expect(takeaway.basket_summary).to eq '4x burger = £9.76, 2x shrimp = £3.76'
      end

      it 'to know my total cost, I should see my order\'s total' do
        expect(takeaway.basket_total).to eq '£13.52'
      end

      it 'to ensure payment is right, it pass when right' do
        expect{takeaway.basket_checkout(13.52)}.not_to raise_error
      end

      it 'to ensure payment is right, it fails when wrong' do
        bad_payment = "Cannot be accepted, you need to pay £13.52"
        expect{takeaway.basket_checkout(12.23)}.to raise_error bad_payment
      end
    end

    # As a customer
    # So that I am reassured that my order will be delivered on time
    # I would like to receive a text such as "Thank you! Your order was placed and will be delivered before 18:52" after I have ordered
  end
end
