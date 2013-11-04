require 'spec_helper'


describe Netsweet::SSO do

  Given(:id) { new_id }
  Given(:customer_attributes) { { external_id: id, entity_id: id, email: 'alex@neo.com', first_name: 'Alex', last_name: 'Burkhart', password: 'super_secret', password2: 'super_secret', give_access: true, access_role: '1017', is_person: true }.freeze }
  Given(:customer) { Netsweet::Customer.create(customer_attributes) }

  after  { delete_customer(customer_attributes[:external_id]) }

  context "map_sso" do
    When(:sso) { Netsweet::SSO.map_sso(customer, customer_attributes[:password]) }
    Then { sso.should_not have_failed(Netsweet::MapSSOFailed) }
  end
end
