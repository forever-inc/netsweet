# Encoding: utf-8

require 'spec_helper'

describe Netsweet::Customer do

  Given(:id) { new_id }
  Given(:customer_attributes) do
    { external_id: id, entity_id: id,
      email: 'alex@neo.com', first_name: 'Alex', last_name: 'Burkhart',
      password: 'super_secret', password2: 'super_secret', give_access: true,
      access_role: '1017', is_person: true }.freeze
  end

  Given(:external_id) { customer_attributes[:external_id] }

  context '.create' do
    Given(:customer) { Netsweet::Customer.create(customer_attributes) }
    Then { expect(customer).to be_a(Netsweet::Customer) }
    And  { expect(customer.email).to eq('alex@neo.com') }
    And  { expect(customer.external_id).to eq(external_id) }
    And  { expect(customer.internal_id).to_not be_blank }
  end

  context '#delete' do
    Given(:customer) { Netsweet::Customer.create(customer_attributes) }
    When(:result)    { customer.delete }
    Then             { expect(result).to be_true }
  end

  context '.get' do
    describe 'when customer exists' do
      before { Netsweet::Customer.create(customer_attributes) }

      Given(:new_customer) { Netsweet::Customer.get(external_id) }
      Then { expect(new_customer).to be_a(Netsweet::Customer) }
      And  { expect(new_customer.email).to eq('alex@neo.com') }
      And  { expect(new_customer.external_id).to eq(external_id) }
      And  { expect(new_customer.internal_id).to_not be_blank }
    end

    describe 'when customer does not exist' do
      When(:result) { Netsweet::Customer.get('nonexistentuser') }
      Then { result.should have_failed(Netsweet::CustomerNotFound) }
    end
  end

end
