load "ThreadPool.rb"
require 'socket'

def handle_client(c, count)
	student_id = 'oldk'
	input = c.gets
	p c.remote_address.ip_address
	arg = "It is executed by thread #{Thread.current[:id]}"
	if input == "HELO text\n"
		arg = ("HELO text\nIP:[#{c.remote_address.ip_address}]\n" +
		"Port:[#{c.remote_address.ip_port}]" +
		"\nStudentID:[#{student_id}]")
	end
	puts "client_#{count} is coming with " + input
	puts "the message sent back is <#{arg}>"
	puts "It is being executed by thread #{Thread.current[:id]}"
	c.puts (arg)
	c.close
	if input == "KILL_SERVICE\n"
		raise SystemExit
	end
end

server = TCPServer.open(ARGV[0].to_i)
thread_pool = ThreadPool.new(10)
puts 'got the thread_pool'
count = 0
while true
	client = server.accept
	thread_pool.schedule(client) do |c|
		count += 1
		handle_client(c, count)
	end
end

