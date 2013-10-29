
require 'spec_helper'


describe Netsweet::SSO do

  Given(:customer_attributes) { { external_id: '1', entity_id: 'Alex Burkhart', email: 'alex@neo.com', first_name: 'Alex', last_name: 'Burkhart', is_person: true } }
  Given(:customer) { Netsweet::Customer.create(customer_attributes) }

  after  { delete_customer(external_id) }

  context ".mapsso" do
    # Pending: this sso call is failing
    # When(:sso) { Netsweet::SSO.mapsso(customer) }
  end
end
