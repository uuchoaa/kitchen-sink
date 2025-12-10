require 'net/http'
require 'uri'
require 'json'

class GoogleFlightsClient
  ENDPOINT = 'https://www.google.com/_/FlightsFrontendUi/data/travel.frontend.flights.FlightsFrontendService/GetShoppingResults'

  def initialize
    # Using static values from captured HAR file
  end

  def search(origin:, destination:, departure_date:, return_date:)
    uri = build_uri
    request = build_request(uri, origin, destination, departure_date, return_date)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    # Handle different response scenarios
    case response
    when Net::HTTPSuccess
      body = decode_response_body(response)
      parse_response(body)
    else
      {
        error: "HTTP #{response.code}",
        message: response.message,
        body: response.body[0..1000]
      }
    end
  rescue => e
    { error: e.message, details: e.backtrace.first(5) }
  end

  private

  def build_uri
    URI.parse("#{ENDPOINT}?#{query_params}")
  end

  def query_params
    # Static values from HAR - will need to be updated over time
    "f.sid=8222137087800291779&bl=boq_travel-frontend-flights-ui_20251208.02_p0&hl=pt-BR&soc-app=162&soc-platform=1&soc-device=1&_reqid=980646&rt=c"
  end

  def build_request(uri, origin, destination, departure_date, return_date)
    request = Net::HTTP::Post.new(uri)

    # Headers from HAR file
    request['Accept'] = '*/*'
    request['Accept-Encoding'] = 'gzip, deflate, br, zstd'
    request['Accept-Language'] = 'pt-BR,pt;q=0.9'
    request['Cache-Control'] = 'no-cache'
    request['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'
    request['Origin'] = 'https://www.google.com'
    request['Pragma'] = 'no-cache'
    request['Referer'] = 'https://www.google.com/travel/flights'
    request['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'

    # Critical anti-bot headers (static from HAR - may expire)
    request['X-Browser-Validation'] = 'AUXUCdutEJ+6gl6bYtz7E2kgIT4='
    request['X-Goog-Ext-259736195-Jspb'] = '["pt-BR","BR","BRL",1,null,[180],null,null,7,[]]'
    request['X-Same-Domain'] = '1'

    # This massive token may need to be refreshed periodically
    request['X-Goog-BatchExecute-Bgr'] = '[";8e-477fQAAZyDDXqUgxfzQ5Cw90raa4mADQBEArZ1MxqRSw6coJDge8DUQvQzgYbpnyPW0x0gJ-0ud3VqLsyvndsGv3Tw52iMrBkoIqNHwAAAC9PAAAAAnUBB2MAQ0vkCCjEm9SbwsECLsDwoGFKIxr7NobQS38ojY7SScZ1jNzW0cHQpdJUZ_ISv70Lg1rEPmlOfsto1setDCVvEbEQwUiEA17F82oewOe81buxN-RCiJGncUH7aI9NtnMbm_L0PZaaQiFe3s__e19JhkS9VVBH2RJDMFpMmaViwISA81H-QKqb-4t8Yis7_zv8uQtR5giXrwuBiQgqDSQjZgbnobOW3W2lJPsPPyIiSZkxLGmCZdpXA0XlmOCMLkeO4Owdserl_NRxuZW5slRQ_OFuCiw0iJOmEzrW0dIAX3YDmFZgJlH3ErKQJV2UxulQ-lSMUouCeCsjlzCgKGm8oZ0tBDsvz-_Rgp3LAlIuJlDcb9Pg0bGpH0jmsg4Lz2AcQk4UtQbvt3kjVpaSRpynn0gueRHEn0B-sFIm1qCvKfYJC07PJX3z316uWOGbPsWwCARzylM8J36sZwvL8oRUBTlLdR5tLLcqEPN4_n9iK8qp0bPsM_sQmntwiNxbWsPMOFciBSW40CFSyop3N1hn_Qa3nIFNgSHQ095w6lTK7nhtKS-Pj4Y0BAUmVHFXYIkW0HSuI19zTEIm-BHDdxk88HIARpHGhEALQ2sSxqVx9HySrJ80I-Y1LjHYSc1Yntgoef9v1aGT4lRsxDTFDWjkhj-PBhw6L8T5iLqiiUYKh2xMfZIC3BTwWMTprxtQKfy4m95g3PnbIpTC0XTS33OuQAPnJ1IXjpgZaHVjQ0DTloVCCxfttpEzeysDQCANU203RbFhnE1o2XLnbwyT98NsVI0DX7bmaLVYe4IaSiDKlPnCC9LUYI-T0usZCdX0lfYiPPrmW0AxWC3jHMDN685o5YDBO5zTg6If8enCnpZdWLieAChYc0Ezzxwo6cFveQ70CwTt_pLBLDBlCWaS3y2hEKL2RquJkOTT81kcHkQgAMZIw3GcQoH2AdznytPAZd92R0V9r69hgDeF3f0atTAkYdPAfCmEnpcT7swsnmPeoXlQgMg_Vma1oH6DKw3RmcBAZXEbXAyfaCmKlagcUvqxEkSe2UuHhWvtfVpYP3dw3cajGxfYrUgPNbzECm4NLVSitWF1eHL6AcV_HpNpqCCL6DO7Zkl4ue-qk_OsEVRsgq1F860NruxzsJuVPYhdxZCeIzPeljH7DRfQvTnP3Pl-BgIVYNPdl6oJRkJD1zxtliKntd_-JVr_r97BNvsoAhrZAkBVHUHTKa69_yVnGbi30p_JX4zM",null,null,9,null,null,null,0,"5"]'

    # Build the payload
    request.body = build_payload(origin, destination, departure_date, return_date)

    request
  end

  def build_payload(origin, destination, departure_date, return_date)
    # Building the request payload structure
    # Format: f.req=[null,"[[],[ flight search params ],0,0,0,1]"]
    
    # Inner search parameters as nested arrays
    search_params = [
      [],
      [
        nil,
        nil,
        1,
        nil,
        [],
        1,
        [1, 0, 0, 0],
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        [
          # Outbound leg
          [
            [[[origin_code(origin), 4]]],
            [[[destination_code(destination), 0]]],
            nil,
            0,
            nil,
            nil,
            departure_date,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            3
          ],
          # Return leg
          [
            [[[destination_code(destination), 0]]],
            [[[origin_code(origin), 4]]],
            nil,
            0,
            nil,
            nil,
            return_date,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            3
          ]
        ],
        nil,
        nil,
        nil,
        1
      ],
      0,
      0,
      0,
      1
    ]

    # The payload is [null, "stringified_array"]
    payload = [nil, search_params.to_json]

    "f.req=#{URI.encode_www_form_component(payload.to_json)}&"
  end

  def origin_code(origin)
    # Map common airports to Google's internal codes
    # For cities, Google uses /m/ codes (from Wikidata/Freebase)
    # For airports, it uses IATA codes with type 0
    case origin.upcase
    when 'GRU', 'SAO', 'CGH', 'VCP'
      '/m/022pfm' # São Paulo city code
    else
      origin.upcase
    end
  end

  def destination_code(destination)
    destination.upcase
  end

  def decode_response_body(response)
    require 'zlib'
    require 'stringio'

    body = response.body
    encoding = response['content-encoding']

    case encoding
    when 'br'
      # Brotli compression - need brotli gem
      begin
        require 'brotli'
        body = Brotli.inflate(body)
      rescue LoadError
        raise "Brotli gem required. Install with: gem install brotli"
      end
    when 'gzip'
      # Gzip compression
      gz = Zlib::GzipReader.new(StringIO.new(body))
      body = gz.read
      gz.close
    end

    body
  end

  def parse_response(body)
    # Remove the security prefix: )]}'
    clean_body = body.gsub(/^\)\]\}'\n\n/, '')

    # The response contains multiple JSON objects separated by newlines
    # Format: number\n[json]\nnumber\n[json]...
    # We want the largest JSON object which contains the flight data

    json_objects = []
    lines = clean_body.lines

    i = 0
    while i < lines.length
      line = lines[i].strip

      # Skip empty lines and numbers
      if line.empty? || line.match?(/^\d+$/)
        i += 1
        next
      end

      # Try to parse as JSON
      begin
        obj = JSON.parse(line)
        json_objects << obj
      rescue JSON::ParserError
        # Skip invalid lines
      end

      i += 1
    end

    # Find the object with flight data (usually the largest one)
    flight_data = json_objects.max_by { |obj| obj.to_s.length }

    {
      status: 'success',
      data: flight_data,
      note: 'Successfully retrieved flight data from Google Flights'
    }
  rescue => e
    {
      error: 'Failed to parse response',
      details: e.message,
      backtrace: e.backtrace.first(3),
      raw_body_preview: body.force_encoding('UTF-8')[0..1000]
    }
  end
end