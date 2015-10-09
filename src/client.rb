require 'socket'

host, port = "127.0.0.1", 2000

s = TCPSocket.open(host, port)
arg = "HELO text\n"
if ARGV.length!=0
	arg = ARGV.join(" ")
end
s.puts(arg)
while line = s.gets
	puts line.chop
end
s.close