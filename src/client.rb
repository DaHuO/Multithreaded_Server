require 'socket'
require 'thread'

host, port = "127.0.0.1", 2000

s = TCPSocket.open(host, port)
# arg = "HELO text\n"
# if ARGV.length!=0
# 	arg = ARGV.join(" ")
# end
# s.puts(arg)
# while line = s.gets
# 	print line
# 	if line.include?("\0")
# 		print 'hi there'
# 	end
# end

while arg = gets
	puts arg
	s.puts(arg)
	Thread.new{
		while line = s.gets
			puts line
		end
	}
end
