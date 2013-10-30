require 'spec_helper'


describe Netsweet::SSO do

  Given(:customer_attributes) { { external_id: '1', entity_id: 'Alex Burkhart', email: 'alex@neo.com', first_name: 'Alex', last_name: 'Burkhart', password: 'super_secret', is_person: true } }
  Given(:customer) { Netsweet::Customer.create(customer_attributes) }

  after  { delete_customer(customer_attributes[:external_id]) }

  context "map_sso" do
    When(:sso) { Netsweet::SSO.map_sso(customer, customer_attributes[:password]) }
    Then { sso.should_not have_failed(Netsweet::MapSSOFailed) }
  end
end
