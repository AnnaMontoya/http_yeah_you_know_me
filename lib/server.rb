require 'socket'
require './lib/request'

class Server
  attr_reader :output, :count, :tcp_server

  def initialize
    @output        = ""
    @tcp_server    = TCPServer.new(9292)
    @request_count = 0
  end

  def start
    loop do
      client  = @tcp_server.accept
      request = Request.new(client)
      @request_count += 1

      if request.path == '/'
        @output = root
      elsif request.path == '/hello'
        @output = hello
      elsif request.path == '/datetime'
        @output = datetime
      elsif request.path == '/shutdown'
        @output = shutdown
      end

      client.puts headers
      client.puts @output
      puts ["Wrote this response:", headers, @output].join("\n")
      puts "\nResponse complete, exiting."
      client.close
    end
  end

  def root
  @output = "<html><head></head><body><pre>
    Verb: POST
    Path: /
    Protocol: HTTP/1.1
    Host: 127.0.0.1
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>"
  end

  def headers
    ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
  end

  def hello
    "Hello, World! #{@request_count}"
  end

  def date_time
    d = DateTime.now
    "#{d.strftime('%H:%M%p on %A, %B %d, %Y')}"
  end

  def shutdown
    puts "Total Requests: #{@request_count}"
    client.puts headers
    client.puts @output
    puts ["Wrote this response:", headers, @output].join("\n")
    puts "\nResponse complete, exiting."
    client.close
  end
end

s = Server.new
s.start
