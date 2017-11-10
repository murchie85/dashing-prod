require "net/http"
require "json"

symbol = "YHOO"
query  = URI::encode "select * from yahoo.finance.quotes where symbol='#{symbol}'&format=json&env=http://datatables.org/alltables.env&callback="

SCHEDULER.every "15s", :first_in => 0 do |job|
  http     = Net::HTTP.new "query.yahooapis.com"
  request  = http.request Net::HTTP::Get.new("/v1/public/yql?q=#{query}")
  response = JSON.parse request.body
  results  = response["query"]["results"]["quote"]

  if results
  quote = {
		name: results['Name'],
		symbol: results['Symbol'],
		price: results['LastTradePriceOnly'],
		change: results['Change'],
		percentchange:  results['PercentChange'],
		lasttradetime: results['LastTradeTime']
	}
  
	send_event "yahoo_stock_quote", quote
  end
  
end
