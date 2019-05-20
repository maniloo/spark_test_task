class ImportProductsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    CSVProductsImporter.new(
      file_path: args.first
    ).call
  end
end
