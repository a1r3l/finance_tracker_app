class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
        publishable_token: Rails.application.credentials[Rails.env.to_sym].dig(:iex_client, :publishable_token),
        secret_token: Rails.application.credentials[Rails.env.to_sym].dig(:iex_client, :secret_token),
        endpoint: Rails.application.credentials[Rails.env.to_sym].dig(:iex_client, :endpoint)
    )
    client.price(ticker_symbol)
  end
end
