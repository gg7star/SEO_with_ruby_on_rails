task br_posts: :environment do

puts''
puts "Ticker?"
@ticker = $stdin.gets.chomp.upcase

puts''
puts "Input search terms"
@terms = $stdin.gets.chomp

puts''
puts "Input date from"
@datefrom = Date.parse($stdin.gets.chomp).to_time.to_i

puts''
puts "Input date to"
@dateto = Date.parse($stdin.gets.chomp).to_time.to_i

      brquery = {
            "key" => '4db9b9cdc8a7a8af6735e41d4c411a5a',
            "query" => @terms,
            "match_mode" => 'extended',
            "highlight" => 0,
            "filter_language" => 'en',
            "body" => 'full_text',
            "filter_date_from" => @datefrom,
            "filter_date_to" => @dateto,
            "sort_mode" => 'time_desc',
            "offset"    =>  0,
            'max_matches' => 10000,
            'limit' => 100,
            'rt'  => 'json'

        }

      response = HTTParty.post("http://api.boardreader.com/v1/Boards/Search", :query => brquery)

      pp JSON.parse(response.body)

      resultsArray = JSON.parse(response.body)

        resultsArray['response']['Matches']['Match'].each do |data|
              Expandedresult.create(
                ticker: @ticker,
                pubDate: data['Published'],
                url: data['Url'],
                title: data['Subject'],
                rawText: data['Text'],
                country: data['Country']
              )
            
    end
end

