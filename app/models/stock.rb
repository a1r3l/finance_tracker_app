class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
        publishable_token: Rails.application.credentials.iex_client.dig(:sandbox, :publishable_token),
        secret_token: Rails.application.credentials.iex_client.dig(:sandbox, :secret_token),
        endpoint: Rails.application.credentials.iex_client.dig(:sandbox, :endpoint)
    )
    client.price(ticker_symbol)
  end
end
