##This works

task keywords: :environment do
require 'alchemyapi'

  puts ""

  puts "Enter ticker:"
    @symbol = $stdin.gets.chomp

  puts ""

  puts "What is the target phrase?"
    @targets = $stdin.gets.chomp

  puts ""

  puts "Date range:"
    @selected_date1 = $stdin.gets.chomp
    @selected_date2 = $stdin.gets.chomp

  alchemyapi = AlchemyAPI.new("b54dc10c4c550ebd9a335461b958ab38bc04d2eb")

  # client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "cognisent")
  #
  # results = client.query("SELECT ticker, pubDate, url, title, rawText, sentimentScore FROM results WHERE rawText like '%Stranger Things%' and ticker='NFLX' limit 66")
  results = Result.where(ticker: "#{@symbol}").where(pubDate: "#{@selected_date1}".."#{@selected_date2}")

  # results.each do |data|
  #   @ticker = data['ticker']
  #   @pubDate = data['pubDate']
  #   @url = data['url']
  #   @title = data['title']
  #   @rawText = data['rawText']
  #   @sentimentScore = data['sentimentScore']
  #
  results.each do |result|
    @ticker = result.ticker
    @pubDate = result.pubDate
    @url = result.url
    @title = result.title
    @rawText = result.rawText
    @sentimentScore = result.sentimentScore
pp @rawText
    @response = alchemyapi.keywords(
    'text',
    @rawText,
    {'max_items'=> 5,
      'sentiment' => 1}
    )
    pp @response

## @response JSON is not the same as what is written below. The output was from another SDK.
## Fix before writing it to database.

    if @response['docSentiment']
      tscore = @response['docSentiment']['score']
      ttype = @response['docSentiment']['type']
    pp @response

      # Target.create(
      #   :ticker => @ticker,
      #   :pubDate => @pubDate,
      #   :url => @url,
      #   :sentimentScore => @sentimentScore,
      #   :targetedScore => tscore,
      #   :targeted_type => ttype
      # )
    end
  end
end
