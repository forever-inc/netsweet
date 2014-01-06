require 'spec_helper'

describe Netsweet::Customer do

  Given(:id) { new_id }
  Given(:customer_attributes) do
    { external_id: id,
      email: gen_email,
      first_name: 'Alex',
      last_name: 'Burkhart',
      password: 'super_secret',
      password2: 'super_secret',
      give_access: true,
      access_role: '1017',
      taxable: true,
      tax_item_string: 'AVATAX',
      is_person: true }.freeze
  end

  Given(:external_id) { customer_attributes[:external_id] }

  context '.create' do
    Given(:customer) { Netsweet::Customer.create(customer_attributes) }
    Then { expect(customer).to be_a(Netsweet::Customer) }
    And  { expect(customer.email).to eq(customer_attributes[:email]) }
    And  { expect(customer.external_id).to eq(external_id) }
    And  { expect(customer.internal_id).to_not be_blank }
  end

  context '#destroy' do
    Given(:customer) { Netsweet::Customer.create(customer_attributes) }
    When(:result)    { customer.destroy }
    Then             { expect(result).to be_true }
  end

  context '.find_by_external_id' do
    describe 'when customer exists' do
      before { Netsweet::Customer.create(customer_attributes) }

      Given(:new_customer) { Netsweet::Customer.find_by_external_id(external_id).refresh }
      Then { expect(new_customer).to be_a(Netsweet::Customer) }
      And  { expect(new_customer.email).to eq(customer_attributes[:email]) }
      And  { expect(new_customer.external_id).to eq(external_id) }
      And  { expect(new_customer.internal_id).to_not be_blank }
    end

    describe 'when customer does not exist' do
      When(:result) { Netsweet::Customer.find_by_external_id('nonexistentuser') }
      Then { expect(result).to have_failed(Netsweet::CustomerNotFound) }
    end
  end

  context '.find_by_internal_id' do
    Given(:internal_id) { Netsweet::Customer.create(customer_attributes).internal_id }

    describe 'when customer exists' do
      Given(:new_customer) { Netsweet::Customer.find_by_internal_id(internal_id).refresh }
      Then { expect(new_customer).to be_a(Netsweet::Customer) }
      And  { expect(new_customer.email).to eq(customer_attributes[:email]) }
      And  { expect(new_customer.external_id).to eq(external_id) }
      And  { expect(new_customer.internal_id).to_not be_blank }
    end

    describe 'when customer does not exist' do
      When(:result) { Netsweet::Customer.find_by_internal_id(12345) }
      Then { expect(result).to have_failed(Netsweet::CustomerNotFound) }
    end
  end

  context '.find_by_email' do
    Given(:customer) { Netsweet::Customer.create(customer_attributes) }

    describe 'when customer exists' do
      Given(:new_customer) { Netsweet::Customer.find_by_email(customer.email).refresh }
      Then { expect(new_customer).to be_a(Netsweet::Customer) }
      And  { expect(new_customer.email).to eq(customer_attributes[:email]) }
      And  { expect(new_customer.external_id).to eq(external_id) }
      And  { expect(new_customer.internal_id).to_not be_blank }
    end

    describe 'when multiple customers exists' do
      Given(:duplicate_customer) do
        Netsweet::Customer.create(customer_attributes.merge(email: customer.email, external_id: new_id, custentity_cutomer_id: new_id))
      end
      When(:result) { Netsweet::Customer.find_by_email(duplicate_customer.email) }
      Then { expect(result).to have_failed(Netsweet::CustomerNotUnique) }
    end

    describe 'when customer does not exist' do
      When(:result) { Netsweet::Customer.find_by_email('nonexistentuser') }
      Then { expect(result).to have_failed(Netsweet::CustomerNotFound) }
    end
  end
end
