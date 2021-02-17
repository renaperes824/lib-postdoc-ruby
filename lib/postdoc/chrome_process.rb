# frozen_string_literal: true
module Postdoc
  class ChromeProcess
    attr_reader :pid, :port

    def initialize(port: Random.rand(65_535 - 1024))
      @port = port
      @pid = Process.spawn "chrome --remote-debugging-port=#{port} --headless",
          out: File::NULL
    end

    def alive?
      @alive ||= test_socket
    rescue
      false
    end

    def kill
      Process.kill 'KILL', pid
      Process.wait pid
    end

    def client
      Client.new port
    end

    private

    def test_socket
      TCPSocket.new('localhost', random_port)
    end
  end
end
