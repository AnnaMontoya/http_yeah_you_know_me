class Request
  attr_reader :accept,
              :client,
              :host,
              :origin,
              :path,
              :port,
              :request_lines,
              :verb

  def initialize(client)
    @client        = client
    @request_lines = []
  end

  def log_request
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    parce_request
  end

  def parce_request
    @verb   = @request_lines[0].split(" ")[0]
    @path   = @request_lines[0].split(" ")[1]
    @host   = @request_lines[0].split(" ")[2]
    @port   = @request_lines[0].split(" ")[3]
    @origin = @request_lines[0].split(" ")[4]
    @accept = @request_lines[0].split(" ")[5]
  end
end
