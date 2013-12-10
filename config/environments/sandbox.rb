module Netsweet
  class Customer
    def self.sample_attributes
      id = rand(10000)
      props = {
        access_role: '1017',
        email: "sample_email#{id}@example.com",
        entity_id: id,
        external_id: id,
        first_name: 'Alex',
        give_access: true,
        is_person: true,
        last_name: 'Burkhart',
        password2: 'super_secret',
        password: 'super_secret'
      }
    end
  end
end
