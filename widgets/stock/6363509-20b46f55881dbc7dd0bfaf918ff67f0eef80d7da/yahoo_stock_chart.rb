require 'net/http'
require 'json'
require 'date'
 
enddate = Date.today
startdate = Date.today - 30

symbol = "YHOO"

# query  = URI::encode "select * from yahoo.finance.quotes where symbol='#{symbol}'&format=json&env=http://datatables.org/alltables.env&callback="
# query = URI::encode "select * from yahoo.finance.historicaldata where symbol='#{symbol}' and startDate='2009-09-11' and endDate='2010-03-10'&format=json&env=http://datatables.org/alltables.env&callback="
query = URI::encode "select * from yahoo.finance.historicaldata where symbol='#{symbol}' and startDate='#{startdate}' and endDate='#{enddate}'&format=json&env=http://datatables.org/alltables.env&callback="


SCHEDULER.every "12h", :first_in => 0 do |job|
  http     = Net::HTTP.new "query.yahooapis.com"
  request  = http.request Net::HTTP::Get.new("/v1/public/yql?q=#{query}")
  response = JSON.parse request.body
  results  = response["query"]["results"]["quote"]
  
  if results
    points = []
  i = 0
	results.each do |q|
	  i += 1
	  points << { x: i, y: q["Close"].to_f}
	end

    send_event("yahoo_stock_chart", { points: points.reverse, symbol: symbol, startdate: startdate, enddate: enddate })
  end
end
