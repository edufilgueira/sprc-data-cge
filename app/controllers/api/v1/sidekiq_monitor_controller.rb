class Api::V1::SidekiqMonitorController < ActionController::API

	FIELDS = [
		:hostname,
		:started_at,
		:pid,
		:tag,
		:concurrency,
		:queues,
		:busy,
		:beat,
		:identity,
	]

	def index
		render :json => sidekiq_status.to_json
	end

	private

	def sidekiq_status
		{
			process_list: process_list,
			queue_list: queue_list
		}		
	end

	def queue_list
		list = Hash.new
		queues.each_with_index do |queue, i|
			list[i] = {
				queue: queue,
				size: Sidekiq::Queue.new(queue).size
			}
		end
		list
	end

	def queues
		@queues ||= Sidekiq::Queue.all.map{|i| i.name}
	end


	def sidekiq_process
		@ps ||= Sidekiq::ProcessSet.new
	end

	def process_list
		list = Hash.new
		sidekiq_process.each_with_index do |process, i|
			properties = Hash.new
			FIELDS.each do |field|
				properties[field] = sanitize(field, process[field.to_s])
			end
			list[i] = properties
  	end
  	list
	end

	def sanitize(field, value)
		if field == :started_at
			return  Time.at(value).to_formatted_s(:long)
		end
		value
	end
	
end