require 'spec_helper'

describe Netsweet::Customer do

  Given(:external_id) { customer_attributes[:external_id] }
  Given(:customer_attributes) { { external_id: '1', entity_id: 'Alex Burkhart', email: 'alex@neo.com', first_name: 'Alex', last_name: 'Burkhart', password: 'super_secret', password2: 'super_secret', give_access: true, access_role: '1017', is_person: true } }

  before(:all)  { delete_customer(external_id) }
  after  { delete_customer(external_id) }

  context ".create" do
    Given(:customer) { Netsweet::Customer.create(customer_attributes) }
    Then { expect(customer).to be_a(Netsweet::Customer) }
    And  { expect(customer.email).to eq("alex@neo.com") }
    And  { expect(customer.external_id).to eq("1") }
    And  { expect(customer.internal_id).to_not be_blank }
  end


  context "#delete" do
    Given(:customer) { Netsweet::Customer.create(customer_attributes) }
    When(:result)    { customer.delete }
    Then             { expect(result).to be_true }
  end

  context ".get" do
    describe "when customer exists" do
      before { Netsweet::Customer.create(customer_attributes) }

      Given(:customer) { Netsweet::Customer.get(external_id) }
      Then { expect(customer).to be_a(Netsweet::Customer) }
      And  { expect(customer.email).to eq("alex@neo.com") }
      And  { expect(customer.external_id).to eq("1") }
      And  { expect(customer.internal_id).to_not be_blank }
    end

    describe "when customer does not exist" do
      Given(:result) { Netsweet::Customer.get("nonexistentuser") }
      Then { result.should have_failed(Netsweet::CustomerNotFound) }
    end
  end

end
