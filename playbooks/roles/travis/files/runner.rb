#!/usr/bin/env ruby

require "pty"
require "socket"

server = TCPServer.new("127.0.0.1", 15782)
socket = server.accept

PTY.spawn("/usr/bin/env", "TERM=xterm", "/bin/bash", "--login", "/Users/travis/build.sh") do |stdout, stdin, pid|
  IO.copy_stream(stdout, socket)

  _, exit_status = Process.wait2(pid)
  File.open("/Users/travis/build.sh.exit", "w") { |f| f.print((exit_status.exitstatus || 127).to_s) }
end

socket.close
