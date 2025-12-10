#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'GoogleFlightsClient'
require 'json'

puts "Testing Google Flights Client"
puts "=" * 50

client = GoogleFlightsClient.new

# Test with the same parameters we captured in HAR
result = client.search(
  origin: 'GRU',
  destination: 'REC',
  departure_date: '2025-12-10',
  return_date: '2025-12-17'
)

puts "\nResult:"
if result[:error]
  puts "Error: #{result[:error]}"
  puts "Details: #{result[:details]}" if result[:details]
  puts "\nRaw body preview:" if result[:raw_body_preview]
  puts result[:raw_body_preview][0..500] if result[:raw_body_preview]
else
  puts "Status: #{result[:status]}"
  puts "Note: #{result[:note]}"

  if result[:data]
    puts "\nData structure:"
    puts "- Type: #{result[:data].class}"
    if result[:data].is_a?(Array)
      puts "- Array length: #{result[:data].length}"
      puts "- First element type: #{result[:data][0].class}" if result[:data][0]
      puts "- First element keys: #{result[:data][0].keys.inspect}" if result[:data][0].is_a?(Hash)
    elsif result[:data].is_a?(Hash)
      puts "- Hash keys: #{result[:data].keys.inspect}"
    end
    puts "- Total size: #{result[:data].to_s.length} characters"

    # Save to file for inspection
    File.write('last_response.json', JSON.pretty_generate(result[:data]))
    puts "\nFull response saved to: last_response.json"
  end
end

puts "\n" + "=" * 50
puts "Test completed!"
