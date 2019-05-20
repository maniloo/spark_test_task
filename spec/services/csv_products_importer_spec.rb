require "rails_helper"

RSpec.describe CSVProductsImporter do
  context "Imports products" do
    before do
      Spree::StockLocation.create(name: 'default')
    end

    it "add products when file data are correct" do
      CSVProductsImporter.new(file_path: "spec/mock_files/sample.csv").call

      expect(Spree::Product.count).to eq(3)
    end

    it "not add products when file data are incorrect" do
      CSVProductsImporter.new(file_path: "spec/mock_files/empty.csv").call

      expect(Spree::Product.count).to eq(0)
    end
  end
end
