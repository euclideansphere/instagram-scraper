#!/usr/bin/env ruby

require "rubygems"
require "json"
require "net/http"
require "uri"
require "csv"

def get_posts()
	access_token = '<<<redacted>>>'
	current_time = Time.now.utc.to_i # apparently in seconds?
	seven_days_ago = current_time - (60 * 60 * 24 * 7000) # todo fix this to 7 days, not 70
	count = 50 # instagram api seems to ignore this and default to 20 anyways.

	uri = URI.parse("https://api.instagram.com/v1/users/self/media/recent?count=#{count}&access_token=#{access_token}")

	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true

	request = Net::HTTP::Get.new(uri.request_uri)

	response = http.request(request)

	if response.code == "200"
		result = JSON.parse(response.body)

		posts = result['data']
			.select { |post| post['created_time'].to_i > seven_days_ago }
			.map { |post|
				{
					'likes' => post.dig('likes', 'count')&.to_i,
					'comments' => post.dig('comments', 'count')&.to_i,
					'created_time' => post['created_time']&.to_i,
					'link' => post['link'],
					'caption' => post.dig('caption', 'text')&.gsub(/\r?\n/, '\n'), # strip newlines
				}
			}

		return posts
	else
		puts 'instagram api could not be fetched.'
	end

	nil
end

posts = get_posts()

puts "total posts found: (#{posts.count})"

sorted = posts.sort { |a, b| b['likes'] <=> a['likes'] }
truncated = sorted.first(10)

CSV.open('top10posts.csv', 'wb') do |csv| 
	csv << truncated.first.keys
	truncated.each do |post|
		csv << post.values
	end
end


