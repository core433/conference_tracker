require "rubygems"
require "open-uri"
require "nokogiri"
require "date"

include EventsHelper

# This script parses http://www.workit.com
#
# It visits the home page, visits all the links of the events listed,
# and uses the Nokogiri html parser gem to extract event name, date,
# city, and more.
#
# Future extensions:
#   1. visit more calendar dates, possibly 2 weeks out
#   2. extend the Event class to be more comprehensive
#   3. Add cron jobs to run this script daily automatically
#   4. Overwrite existing events instead of adding new ones by checking against event names, for example
#
# To run in rails development environment:
#   bundle exec rails runner "eval(File.read 'script/parser_workit.rb')"
#
# To run on deployed Heroku app:
#   heroku run rails runner script/parser_workit.rb
#
#

#---------------------------------
# GLOBALS
#---------------------------------
PAGE_URL = "http://www.workit.com/events/cityevents.cfm"
page = Nokogiri::HTML(open(PAGE_URL))
debug = false

event_nodes = page.xpath("//td/table/tbody/tr/td[@align='left']/font/font/a").map { |link| link['href'] }
#time_nodes = page.search("//tr/td[@width='100%']/b/font/font/text()")

#---------------------------------
# PARSING
#
# Each event node (node) is a partial link to the specific event
# gathered from each link on the home page.  We will visit the
# event page, and gather all the details, which are stored in
# "tr" elements.  By inspecting their "td"[class=formlabel] labels,
# we can tell what detail they are (e.g., event name) and create
# our Event objects one at a time.
#
#---------------------------------
event_nodes.each do |node|

	event_URL = "http://www.workit.com/events/" + node.to_str
	event_page = Nokogiri::HTML(open(event_URL))

	if !debug
		new_event = Event.new()
	end

	# Each row in the event page is a detail
	detail_nodes = event_page.xpath("//tr[@bordercolor='FFFFFF']")
	
	detail_nodes.each do |detail|
		title = detail.xpath("td[@class='formlabel']/text()")
		title = title.text.gsub(/\s+/, ' ')
		title = title.strip

		if title == "Event Name"
			info = detail.xpath("td[@class='formcontent']/font/b/font/text()")
			info = info.text.gsub(/\s+/, ' ')
			info = info.strip
			if debug
				puts info
			else
				puts info
				new_event.name = info.to_str
			end
		elsif title == "City"
			info = detail.xpath("td[@class='formcontent']")
			info = info.text.gsub(/\s+/, ' ')
			info = info.strip
			if debug
				puts info
			else
				new_event.city = info.to_str
			end
		elsif title == "Date"
			info = detail.xpath("td[@class='formcontent']")
			info = info.text.gsub(/\s+/, ' ')
			info = info.strip
			if !debug
				event_date = DateTime.strptime(info, "%A %b %d, %Y")	# e.g., Thursday April 18, 2013
				new_event.time = event_date
			end
		elsif title == "Time"
			info = detail.xpath("td[@class='formcontent']")
			info = info.text.gsub(/\s+/, ' ')
			info = info.strip
			start_end_times = GetStartEndTimeFromString(info, "workit")
			start_time = start_end_times[0]
			end_time = start_end_times[1]
			if !debug
				old_time = new_event.time
				updated_time = DateTime.new(old_time.year, old_time.month, old_time.mday, start_time.hour, start_time.minute)
				new_event.time = updated_time
			end
		else
			info = detail.xpath("td[@class='formcontent']")
			info = info.text.gsub(/\s+/, ' ')
			info = info.strip
			if title == "Event Type"
				new_event.event_type = info
			elsif title == "Event Area"
				new_event.field = info
			elsif title == "Hosted By"
				new_event.host = info
			elsif title == "Description"
				new_event.description = info
			elsif title == "Cost"
				new_event.cost = info
			elsif title == "Ticket URL"
				new_event.ticket_url = info
			elsif title == "Other ticket Information"
				new_event.ticket_info = info
			elsif title == "Organization Description"
				new_event.organization_description = info
			elsif title == "Event Contact Info"
				new_event.contact = info
			elsif title == "Contact Phone"
				new_event.contact_phone = info
			elsif title == "Venue"
				new_event.venue = info
			elsif title == "Venue Address"
				new_event.venue_addr = info
			end
		end

	end

	if !debug
		if !new_event.save()
			puts '-----------------------------------------------------'
			puts 'SAVE FAILED' + " ---- " + new_event.name + " ---- " + new_event.city + " ---- " + new_event.time.strftime("%m/%d/%Y %H:%M")
			puts '-----------------------------------------------------'
		end
	end

end













