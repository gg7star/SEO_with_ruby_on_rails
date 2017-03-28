task news_keywords: :environment do

require 'alchemyapi'

  puts ""

  puts "Enter ticker:"
    @ticker = $stdin.gets.chomp

  puts ""

  puts "Date range:"
    @selected_date1 = $stdin.gets.chomp
    @selected_date2 = $stdin.gets.chomp

  alchemyapi = AlchemyAPI.new("b54dc10c4c550ebd9a335461b958ab38bc04d2eb")

  results = New.where(ticker: "#{@ticker}").where(pubDate: "#{@selected_date1}".."#{@selected_date2}")

  results.each do |result|
    @ticker = result.ticker
    @pubDate = result.pubDate
    @url = result.url
    @subject = result.subject
    @rawText = result.rawText

pp @rawText
    @response = alchemyapi.keywords(
    'text',
    @rawText,
    {'max_items'=> 5,
      'sentiment' => 1}
    )
    pp @response

    # if @response['docSentiment']
    #   tscore = @response['docSentiment']['score']
    #   ttype = @response['docSentiment']['type']
    # pp @response












  end
end
