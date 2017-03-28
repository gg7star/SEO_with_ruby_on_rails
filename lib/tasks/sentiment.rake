##This works

task sentiment: :environment do
  require 'alchemyapi'

  alchemyapi = AlchemyAPI.new("b54dc10c4c550ebd9a335461b958ab38bc04d2eb")

  @offset = 0
  @more = 1

  puts ""
  puts "Enter ticker:"
  @symbol = $stdin.gets.chomp.upcase

  puts "What are the targeted keywords"
  @targetsum = $stdin.gets.chomp
  @targets = @targetsum.split(' ')

  puts "Keep the words together or separate?"
  @kn = $stdin.gets.chomp

  while (@more == 1)

      results = Result.where(ticker: @symbol)

      @targets.each do |target|
        results = results.where("rawText LIKE ?", "%#{target}%")
      end

      results.each do |result|
        @ticker = result.ticker
        @pubDate = result.pubDate
        @url = result.url
        @title = result.title
        @rawText = result.rawText
        @sentimentScore = result.sentimentScore


      if @kn == "together"
        @together = @targets.join(' ')

        @response = begin
          alchemyapi.sentiment_targeted(
          'text',
          @rawText,
          @together,

        )
        rescue JSON::ParserError
        end

      else
        @separate = @targets.join('| ')

        @response = begin
          alchemyapi.sentiment_targeted(
          'text',
          @rawText,
          @separate
        )
        rescue JSON::ParserError
        end

      end

    #
    #   # client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "cognisent")
    #   #
      # results = client.query("SELECT ticker, pubDate, url, title, rawText, sentimentScore FROM results WHERE rawText like '%Stranger Things%' and ticker='NFLX' limit 66")


    #
    #   # results.each do |data|
    #   #   @ticker = data['ticker']
    #   #   @pubDate = data['pubDate']
    #   #   @url = data['url']
    #   #   @title = data['title']
    #   #   @rawText = data['rawText']
    #   #   @sentimentScore = data['sentimentScore']
    #   #
    #   #   puts @sentimentScore
    #
    # puts @rawText
    # puts @targets


        pp @response
        #
        if @response && @response['status'] == 'OK'
          tscore = @response['results'][0]['sentiment']['score']
          ttype = @response['results'][0]['sentiment']['type']

            Target.create(
              :ticker => @ticker,
              :pubDate => @pubDate,
              :url => @url,
              :sentimentScore => @sentimentScore,
              :targetedKeywords => @targetsum,
              :targetedScore => tscore,
              :targeted_type => ttype
            )
        end
      end
  end
end
