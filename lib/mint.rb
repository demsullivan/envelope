require 'net/https'
require 'json'
require 'uri'
require 'date'

class Mint
  class AuthenticationError < StandardError; end
  class MintError < StandardError; end

  BASE_URL     = 'https://wwws.mint.com'
  OVERVIEW_URL = '/overview.event'
  LOGIN_URL    = "/loginUserSubmit.xevent"
  CSV_URL      = "/transactionDownload.event"
  SERVICE_URL  = "/bundledServiceController.xevent"
  JSON_URL     = "/getJsonData.xevent"

  def initialize(credentials)
    @credentials = credentials
  end

  def net_http_class
    uri = URI.parse BASE_URL
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http
  end

  def get_user_pod(email)
    res = net_http_class.post("/getUserPod.xevent", "username=#{email}", {"Cookie" => "username=\"#{email}\"; "})
    if res.code == '200' or res.code == '302'
      all_cookies = res.get_fields('set-cookie')
      cookies_array = Array.new
      all_cookies.each {|cookie|
        if not cookie['mintPN'].nil?
          cookies_array.push cookie.split('; ')[0]
        end
      }
      cookies_array.push('mintUserName="#{email}"')
      cookies_array.join('; ')
    end
  end
  # Authenticates with Mint:
  #
  #   * If successful, assigns the cookies returned to an instance variable
  #   * If an error is detected, raises an +AuthenticationError+ exception
  #
  def authenticate
    payload = {
      :username => @credentials.username,
      :password => @credentials.password,
      :task     => 'L',
      :nextPage => '',
      :browser => 'Chrome',
      :browserVersion => 32,
      :os => 'v'
    }

    pod_cookie = get_user_pod @credentials.username

    res = net_http_class.post LOGIN_URL, URI.encode_www_form(payload), {"Cookie" => pod_cookie, "Accept" => "application/json"}

    if res.code == '200' or res.code == '302'
      @token = JSON.parse(res.body)['sUser']['token']
      all_cookies = res.get_fields('set-cookie')
      cookies_array = Array.new

      all_cookies.each {|cookie|
        cookies_array.push cookie.split('; ')[0]
      }

      @cookies = cookies_array.join('; ')

    end

    res = net_http_class.get(OVERVIEW_URL, {"Cookie" => @cookies})

  end

  def transactions(args)
    args = {:startDate => "05/26/2014", :endDate => "05/28/2014",
      :filterType => "cash", :offset => 0, :comparableType => 0,
      :queryNew => ''}.merge args

    args[:startDate] = args[:startDate].strftime("%m/%d/%Y") if args[:startDate].is_a?(Date)
    args[:endDate] = args[:endDate].strftime("%m/%d/%Y") if args[:endDate].is_a?(Date)

    get_json_data("transactions", args)['set'][0]['data']
  end

  %w(accounts categories tags).each do |data_type|
    define_method(data_type.to_sym) { get_json_data data_type }
  end

  private
  def call_service(service, task, args)
    payload = {:input => JSON.dump({:service => service, :task => task, :args => args, :id => 42})}
    net_http_class.get("#{SERVICE_URL}?legacy=false&#{URI.encode_www_form(payload)}", {"Cookie" => @cookies}).body
  end

  def get_json_data(task, args={})
    args.merge! :task => task, :rnd => Time.new.to_i
    www_args = URI.encode_www_form(args).gsub /\%2F/, "/"
    puts "getting #{JSON_URL}?#{www_args}"
    res = net_http_class.get("#{JSON_URL}?#{www_args}", {"Cookie" => @cookies})
    JSON.parse(res.body)
  end

end
