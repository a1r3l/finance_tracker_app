class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials[Rails.env.to_sym].dig(:iex_client, :publishable_token),
      secret_token: Rails.application.credentials[Rails.env.to_sym].dig(:iex_client, :secret_token),
      endpoint: Rails.application.credentials[Rails.env.to_sym].dig(:iex_client, :endpoint)
    )

    begin
      new(
        ticker: ticker_symbol, 
        name: client.company(ticker_symbol).company_name, 
        last_price: client.price(ticker_symbol)
      )
    rescue => exception
      return
    end
  end

  def self.check_stock(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
