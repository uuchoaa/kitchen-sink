#!/usr/bin/env ruby
# Debug script to see what we're actually getting back

require_relative 'GoogleFlightsClient'
require 'json'
require 'zlib'
require 'stringio'

client = GoogleFlightsClient.new

# Capture the raw response
uri = URI.parse("#{GoogleFlightsClient::ENDPOINT}?f.sid=8222137087800291779&bl=boq_travel-frontend-flights-ui_20251208.02_p0&hl=pt-BR&soc-app=162&soc-platform=1&soc-device=1&_reqid=980646&rt=c")

puts "Testing with URI: #{uri}"
puts "\n" + "=" * 50

result = client.search(
  origin: 'GRU',
  destination: 'REC', 
  departure_date: '2025-12-10',
  return_date: '2025-12-17'
)

if result[:error]
  puts "Error: #{result[:error]}"
  
  # Try to see what the response actually looks like
  if result[:raw_body]
    body = result[:raw_body]
    
    puts "\nFirst 20 bytes (hex):"
    puts body.bytes[0..20].map { |b| b.to_s(16).rjust(2, '0') }.join(' ')
    
    puts "\nChecking if it's a Google error page..."
    if body.include?('<!DOCTYPE') || body.include?('<html')
      puts "It's an HTML page (probably an error)"
      puts body[0..1000]
    end
  end
end
