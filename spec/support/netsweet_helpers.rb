def delete_customer(id)
  Netsweet::Customer.get(id).delete
rescue Netsweet::CustomerNotFound
  nil #swallow
end
