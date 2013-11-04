def delete_customer(id)
  Netsweet::Customer.get(id).delete
rescue Netsweet::CustomerNotFound
  nil #swallow
end

def new_id
  SecureRandom.urlsafe_base64(32)
end
