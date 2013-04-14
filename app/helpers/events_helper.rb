module EventsHelper

	# Currently returns a list of DateTime objects, starting
	# from today, to 10 days out in the future.  In the future,
	# will need to extend this so that it can take a start date
	# and an end date, and provide those dates
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
