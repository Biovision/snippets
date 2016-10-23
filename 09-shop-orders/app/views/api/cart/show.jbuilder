json.data do
  json.(@order, :slug, :price, :items_count)
  json.texts do
    json.items_count t(:item, count: @order.items_count)
  end
  json.order_items @order.order_items do |order_item|
    json.order_item do
      json.(order_item, :id, :item_id, :price, :quantity, :total_price)
    end
  end
end