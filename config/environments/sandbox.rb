module Netsweet
  class Customer
    def self.sample_attributes
      id = rand(10000)
      props = {
        external_id: "abc#{id}",
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
