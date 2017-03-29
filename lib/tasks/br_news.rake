task br_news: :environment do

  puts''
  puts "Ticker?"
  @ticker = $stdin.gets.chomp.upcase
  
  puts''
  puts "Input search terms"
  @terms = $stdin.gets.chomp
  
  puts''
  puts "Input date from"
  @datefrom = Date.parse($stdin.gets.chomp).to_time.to_i
  puts "@datefrom = #{@datefrom}"

  puts''
  puts "Input date to"
  @dateto = Date.parse($stdin.gets.chomp).to_time.to_i
  puts "@dateto = #{@dateto}"

  # Initialize
  @max_matches = 10000
  @limit = 100
  @offset = 0
  @query_offset = 0
  @total_found = 0
  @total = 0
  params = {
      ticker: @ticker,
      terms: @terms,
      datefrom: @datefrom,
      dateto: @dateto,
      max_matches: @max_matches,
      limit: @limit,
      offset: @offset
  }

  # Method to post a request
  def request_board_reader(params, result = nil, total_found_first = nil)
    if (@query_offset % @max_matches == 0) && (@query_offset != 0)
      puts "", "=================================================", ""
      print_total = total_found_first - @offset
      puts "Remaining Records: #{print_total}"
      @query_offset = 0
      @offset = 0
      date = result[:pubDate]
      puts "filter_date_from is now: #{date}: #{date.to_time.to_i}";
      # params[:filter_date_from] = date.to_time.to_i
      params[:dateto] = date.to_time.to_i
      puts "", "=================================================", ""
    end
    # Make queary parameters for BoardReader
    board_reader_query = {
          "key" => '4db9b9cdc8a7a8af6735e41d4c411a5a',
          "query" => params[:terms],
          "match_mode" => 'extended',
          "highlight" => 0,
          "filter_language" => 'en',
          "body" => 'full_text',
          "filter_date_from" => params[:datefrom],
          "filter_date_to" => params[:dateto],
          "sort_mode" => 'time_desc',
          "offset"    =>  @query_offset,
          'max_matches' => params[:max_matches],
          'limit' => params[:limit],
          'rt'  => 'json'
      }

      begin
        # Post a request with above query and parse the response
        response = HTTParty.post("http://api.boardreader.com/v1/News/Search", :query => board_reader_query)
        case response.code
          when 200

          when 404
            puts "Not found!"
            return 0
          when 500...600
            puts "ZOMG ERROR #{response.code}"
            return 0
        end

        pp JSON.parse(response.body)
        results_array = JSON.parse(response.body)

      rescue Exception => e
        puts "Exception class: #{e.message}"
        return 0;
      end

      # Print total count in case first call.
      if (results_array['response']['TotalFound'] != nil) && (results_array['response']['TotalFound'].to_i > 0)
        if @offset == 0
          @total_found = results_array['response']['TotalFound'].to_i
          total_found_first = @total_found
          puts "Total Found: #{@total_found}"
        end

        news = nil
        # Count all results and inter into database
        results_array['response']['Matches']['Match'].each do |data|
          @total += 1;
          begin
            news = New.create(
              ticker: @ticker,
              pubDate: data['Published'],
              url: data['Url'],
              subject: data['Subject'],
              rawText: data['Text']
            )
          rescue Mysql2::Error => e
            puts "MySQL error:  #{e.message}"
            next
          rescue  ActiveRecord::RecordInvalid => e
            puts "ActiveRecord error: #{e.record.errors}"
            next
          rescue Exception => e
            puts "Exception class: #{e.message}"
            puts "\nWill skip to store this record(offset #{@offset}) and continue next record."
            next
          end
        end # of loop for resultsArray

        @query_offset += @limit
        @offset += @limit
        puts "Found: #{total_found_first - @query_offset}"
        puts "offset: #{@query_offset}"

        if (total_found_first != nil) && total_found_first > @offset
          request_board_reader(params, news, total_found_first)
        end
        return 1
      else
        puts "Error"
        return 0
      end
  end # of request_board_reader method


  # Get all results for conditions with recurrence function call
  result = request_board_reader(params)
  if result == 1
    puts "Results and Stocks ahas been updated."
  end

end
