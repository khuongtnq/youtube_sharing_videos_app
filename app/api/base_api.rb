class BaseApi < Grape::API
  mount V1::AppApi
  add_swagger_documentation mount_path: '/api-docs'
end