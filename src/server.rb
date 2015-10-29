load "ThreadPool.rb"
require 'socket'
require 'net/http'

def handle_client(c, count, server)
	student_id = 'oldk'
	while input = c.gets
		puts 'got one'
		p c.remote_address.ip_address
		arg = input

		puts "one to four #{input[0,4]}"
		if input[0,4] == "HELO"
			arg = "#{input}"+"IP:#{$ip}\n" +
			"Port:#{$port}" +
			"\nStudentID:#{student_id}"
		end
		puts "client_#{count} is coming with #{input}"
		puts "the message sent back is \n<\n#{arg}\n>"
		puts "It is being executed by thread #{Thread.current[:id]}"
		c.puts (arg)
		if input == "KILL_SERVICE\n"
			c.close
			server.close
			raise SystemExit
			
		end
	end
end
uri = URI('http://ipecho.net/plain')
body = Net::HTTP.get(uri)
if body.length!=0
	$ip = body
else
	$ip = '127.0.0.1'
end
$port = '3457'
if ARGV.length != 0 
	$port = ARGV[0]
end
server = TCPServer.open($port)
thread_pool = ThreadPool.new(5)	#to create a thread pool with 10 threads
puts 'got the thread_pool'
count = 0
while true
	client = server.accept
	thread_pool.schedule(client) do |c|
		count += 1
		handle_client(c, count, server)
	end
end
