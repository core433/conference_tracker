module EventsHelper


	def GetStartEndTimeFromString(string, source_name)
		if source_name == "workit"
			string = string.gsub(/\s+/, "")
			split_index = string.index('to')

			# If the time is e.g., "6:00PM to 9:00PM", we have valid start and end times
			# otherwise if it's just "6:00PM", set end time to start time
			if split_index == nil
				start_string = end_string = string
			else
				start_string = string[0.. split_index-1]
				end_string = string[split_index+'to'.length.. string.length]
			end

			start_time = DateTime.strptime(start_string, "%I:%M%p")
			end_time = DateTime.strptime(end_string, "%I:%M%p")

			return [start_time, end_time]

		end

	end

	# Given a string for the h:m time and a DateTime
	# object holding the y/m/d, returns a combined DateTime object
	# @time_string is e.g., 5:30PM
	# @date_time holds the year, month, and day
	# return a combined datetime object with the hour, mins, day, month, year
	#
	def getDateTimeByString(time_string, datetime)

		time_string = time_string.strip

		colon_i = time_string.index(':')
		minutes = time_string[colon_i+1.. colon_i+2].to_i
		hours = time_string[0.. colon_i-1].to_i

		am_pm_string = time_string[-2,2].downcase
		if am_pm_string == "pm"
			hours += 12
		end

		#puts hours.to_s + ":" + minutes.to_s + "/" + am_pm_string

		return DateTime.new(datetime.year, datetime.month, datetime.day, hours, minutes)

	end

	# Given a string month_name, returns the integer corresponding
	# to that month.  For example, January = 1, February = 2.
	# Handles full month names and standard 3-letter shorthand,
	# e.g., January/Jan, February/Feb, etc.
	#
	def getMonthIntByMonthName(month_name)
		month_name = month_name.downcase
		months_array = ['january', 'february', 'march', 'april', 'may', 'june', 'july',
			'august', 'september', 'october', 'november', 'december']
		months_short_array = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug',
			'sep', 'oct', 'nov', 'dec']

		month_index = months_array.index( month_name )
		month_short_index = months_short_array.index( month_name )

		if month_index != nil
			return month_index + 1
		end

		if month_short_index != nil
			return month_short_index + 1
		end

		return nil
	end


	# Currently returns a list of DateTime objects, starting
	# from today, to 10 days out in the future.  In the future,
	# will need to extend this so that it can take a start date
	# and an end date, and provide those dates
	#
	def getDatesToDisplay()

		numDays = 10
		retDays = []

		for i in 0..10
			a_date = (DateTime.now + i.days)
			retDays.push(a_date)
		end

		return retDays
	end
end
