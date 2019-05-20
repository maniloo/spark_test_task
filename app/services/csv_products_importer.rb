require 'csv'

PARAMS_KEY_MAPPER = {
  availability_date: "available_on"
}

class CSVProductsImporter
  attr_reader :successfully_imported

  def initialize(file_path:)
    @file_path = file_path
    @stock_location = Spree::StockLocation.find_by(name: "default")
    @successfully_imported = 0
  end

  def call
    CSV.foreach(@file_path, col_sep: ";", headers: true) do |row|
      product = prepare_product(row)

      if product.valid?
        product.save
        @successfully_imported += 1
      end
    end

    @successfully_imported > 0
  end


  private

  def prepare_product(row)
    product_params = {}

    row.to_h.compact.map do |k, v|
      new_key = k
      mapped_key = PARAMS_KEY_MAPPER[k.to_sym]
      new_key = mapped_key if mapped_key
      product_params[new_key] = v
    end

    if product_params["price"]
      product_params["price"] = product_params["price"].tr(',', '.')
    end

    stock_total = product_params.delete("stock_total")
    category_name = product_params.delete("category")

    product = Spree::Product.new(product_params)
    product.shipping_category = Spree::ShippingCategory.find_or_initialize_by(name: category_name)
    product.master.stock_items.build(stock_location_id: @stock_location.id, count_on_hand: stock_total)

    product
  end
end
