json.array!(@carts) do |cart|
  json.extract! cart, :id, :user_id, :product_id, :quantity
  json.url cart_url(cart, format: :json)
end
