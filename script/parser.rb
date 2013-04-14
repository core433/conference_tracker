require "rubygems"
require "open-uri"
require "nokogiri"
require "date"

# To run in rails environment (so it goes on server),
# run the following command:
#
# bundle exec rails runner "eval(File.read 'script/parser.rb')"
#
# to run on heroku, use the following command:
# heroku run rails runner script/parser.rb

PAGE_URL = "http://www.workit.com/events/cityevents.cfm"

page = Nokogiri::HTML(open(PAGE_URL))

debug = false

cur_datetime = nil

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

	return 1
end

# @time_string is e.g., 5:30PM
# @date_time holds the year, month, and day
# return a combined datetime object with the hour, mins, day, month, year
def getTimeByString(time_string, datetime)

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

# WORKIT.COM
# Getting the dates and event entries
nodes = page.search("//td/table/tbody/tr/td[@align='left']/font/font/a/font/font/text()|
	//tr/td[@width='100%']/b/font/font/text()")

# Getting the dates, e.g., Friday, April 26, 2013
#nodes = page.search("//tr/td[@width='100%']/b/font/font/text()")


nodes.each do |node|

	#content = node.to_str.gsub(/\s+/, "")
	content = node.to_str

	#if content.starts_with?('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
	if content.match(/^Monday|^Tuesday|^Wednesday|^Thursday|^Friday|^Saturday|^Sunday/)
		#puts "\n\n"
		#puts "-----------------------------------------------"
		#puts content
		#puts "-----------------------------------------------"

		# parse the time, which comes in format e.g., "Monday, May 13, 2013"
		time_arr = content.split(/,/)
		weekday = time_arr[0].strip		# e.g., "Monday"
		dateday = time_arr[1].strip		# e.g., "May 13"
		year = time_arr[2].strip		# e.g., "2013"

		month_day = dateday.split(/ /)
		#puts month_day[0]		# this is the month, e.g., "May"
		#puts month_day[1]		# this is the day, e.g., "13"
		month_int = getMonthIntByMonthName(month_day[0])

		cur_datetime = DateTime.new(year.to_i, month_int.to_i, month_day[1].to_i)

	else
		content_arr = content.split(/\"/)
		# need to catch exception where content_arr has less than 3 items
		event_time = content_arr[0].strip
		event_name = content_arr[1].strip
		event_city = content_arr[2].strip

		event_datetime = getTimeByString(event_time, cur_datetime)

		puts event_name + " - " + event_city + " - " + event_datetime.strftime("%m/%d/%Y, %H:%M")

		if (!debug)
			event = Event.new(name: event_name, city: event_city, time: event_datetime)
			event.save
		end
	end

end


