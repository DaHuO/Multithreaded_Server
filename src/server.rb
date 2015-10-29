load "ThreadPool.rb"
require 'socket'

def handle_client(c, count)
	student_id = 'oldk'
	while input = c.gets
		puts 'got one'
		p c.remote_address.ip_address
		arg = "It is executed by thread #{Thread.current[:id]}\n" +
			"The origin message is #{input}"
		# if input == "HELO text\n"
		# 	arg = "HELO text\nIP:[#{c.remote_address.ip_address}]\n" +
		# 	"Port:[#{c.remote_address.ip_port}]" +
		# 	"\nStudentID:[#{student_id}]"
		# end
		puts "one to four #{input[0,4]}"
		if input[0,4] == "HELO"
			arg = "#{input}"+"IP:[#{c.remote_address.ip_address}]\n" +
			"Port:[#{c.remote_address.ip_port}]" +
			"\nStudentID:[#{student_id}]"
			puts "got there"
		end
		puts "client_#{count} is coming with #{input}"
		puts "the message sent back is \n<\n#{arg}\n>"
		puts "It is being executed by thread #{Thread.current[:id]}"
		c.puts (arg)
		if input == "KILL_SERVICE\n"
			raise SystemExit
		end
	end
end

port = 3457 
if ARGV.length != 0 
	port = ARGV[0].to_i
end
server = TCPServer.open(port)
thread_pool = ThreadPool.new(5)	#to create a thread pool with 10 threads
puts 'got the thread_pool'
count = 0
while true
	client = server.accept
	thread_pool.schedule(client) do |c|
		count += 1
		handle_client(c, count)
	end
end
