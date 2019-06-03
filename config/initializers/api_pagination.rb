ApiPagination.configure do |config|
  config.paginator = :kaminari
  config.page_header = "Current-Page"
  config.page_param = :page
end
