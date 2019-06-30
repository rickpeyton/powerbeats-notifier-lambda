begin
  require "dotenv/load"
rescue StandardError; end # rubocop:disable Lint/HandleExceptions
require "apple_store_inventory_checker"
require "json"
require "logger"
require "twilio-ruby"

TWILIO_SID = ENV["TWILIO_SID"]
TWILIO_TOKEN = ENV["TWILIO_TOKEN"]
TWILIO_FROM_NUMBER = ENV["TWILIO_FROM_NUMBER"]
TWILIO_TO_NUMBER = ENV["TWILIO_TO_NUMBER"]

def lambda_handler(**) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  logger = Logger.new(STDOUT)

  response = AppleStoreInventoryChecker.retrieve("MV6Y2LL/A", zip: "37064", max_distance: 160)
  logger.info "Inventory Response #{response.inspect}"

  in_stock = response.select(&:in_stock?)

  return { statusCode: 200, body: "No Inventory Found" } unless in_stock.any?

  twilio_client = Twilio::REST::Client.new(TWILIO_SID, TWILIO_TOKEN)

  in_stock.each do |stock|
    message = <<~MESSAGE
      PowerBeats Pro In Stock!
      #{stock.store} #{stock.city}, #{stock.state}
      #{stock.distance} miles
      #{stock.url}
    MESSAGE
    twilio_result = twilio_client.api.account.messages.create(
      from: TWILIO_FROM_NUMBER,
      to: TWILIO_TO_NUMBER,
      body: message
    )
    logger.info "Twilio Message SID #{twilio_result.sid}"
  end

  { statusCode: 200 }
rescue StandardError => e
  { statusCode: 500, body: e }
end
