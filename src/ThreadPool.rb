require 'thread'

class ThreadPool
	def initialize(size)
		@size = size
		@jobs = Queue.new

		Array.new(@size) do |i|
			Thread.new {
				Thread.current[:id] = i
				args, job = @jobs.pop
				job.call(*args)
			}
		end
	end

	def schedule(*args, &block)
		@jobs << [args, block]
	end

end


