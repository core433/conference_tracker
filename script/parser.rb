require "rubygems"
require "open-uri"
require "nokogiri"

PAGE_URL = "http://www.workit.com/events/cityevents.cfm"

page = Nokogiri::HTML(open(PAGE_URL))

#puts page

#puts page.css("title").text
#links = page.css("a")
#puts links.length

# Getting the dates and event entries
nodes = page.search("//td/table/tbody/tr/td[@align='left']/font/font/a/font/font/text()|
	//tr/td[@width='100%']/b/font/font/text()")

# Getting the dates, e.g., Friday, April 26, 2013
#nodes = page.search("//tr/td[@width='100%']/b/font/font/text()")

nodes.each do |node|

	content = node.to_str.gsub(/\s+/, "")

	#if content.starts_with?('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
	if content.match(/^Monday|^Tuesday|^Wednesday|^Thursday|^Friday|^Saturday|^Sunday/)
		puts "\n\n"
		puts "-----------------------------------------------"
		puts content
		puts "-----------------------------------------------"

	else
		puts content
	end

end


