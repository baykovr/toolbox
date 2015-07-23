#!/usr/bin/env ruby
# Split the remainder of the day into 30min blocks.

if __FILE__ == $PROGRAM_NAME
	hour = Time.now.hour
	min  = Time.now.min
	puts "Current : #{hour}:#{min}"

	prefix = "\t"
	chunk  = 0
	block  = 0
	
	# hour 0..23
	hours_left  = 24 - hour
	#aval_chunks = hours_left * 2
	#aval_blocks = aval_chunks / 3 
	#puts "Blocks available #{aval_blocks}"

	until hour == 24
		printf("Block [%d]\n",block)
		for i in [0,1]
		printf("\t%d:%02d\n",hour,i*30)
		chunk+=1
		if chunk == 3
			chunk = 0
		end
	end
		hour  += 1
		block += 1
	end
end
