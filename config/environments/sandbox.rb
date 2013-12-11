module Netsweet
  class Customer
    def self.sample_attributes
      id = rand(10000)
      props = {
        custentity_cutomer_uuid: id, # yes, 'customer' is misspelled in netsuite
        access_role: '1017',
        email: "sample_email#{id}@example.com",
        first_name: 'Alex',
        last_name: 'Burkhart',
        give_access: true,
        is_person: true,
        password2: 'super_secret',
        password: 'super_secret'
      }
    end
  end
end
