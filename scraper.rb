#!/bin/env ruby
# encoding: utf-8


# This script started off as a shamelessly plagiarized version of the Popolo/ EveryPolitician Virgin Islands example scraper (thanks, guys!!)
# Hopefully it isn't too similar but it gave me a very readable starting point, as a ruby beginner. :) 
# - Alison

# Original is here: 
# https://github.com/tmtmtmtm/us-virgin-islands-legislature/blob/master/scraper.rb

require 'scraperwiki'
require 'nokogiri'
require 'open-uri'

require 'time' #this allows parsing the start dates etc

# This version uses fake data for start and end dates, because I am trying to get enough of the code up and running that I can start to see a South Australian version of the site ... 

sa_mps_url = 'https://www2.parliament.sa.gov.au/Internet/DesktopModules/Memberlist.aspx'

def noko_for(url)
  Nokogiri::HTML(open(url).read)
end

def scrape_list(url)
  noko = noko_for(url)
  noko.css('table table table tr').each do |line|
    party_abbrev = line.css('td')[1].text.to_s
    if (line.css('td')[2].text.to_s == "LC")
      line.css('a[href*="MemberDrill"]').each do |a|
        mp_url = URI.join url, a.attr('href')
        scrape_person(a.text, mp_url, party_abbrev)
      end
    else
       puts "\n(+ lower house member ignored)"
    end
  end
end

def scrape_person(mp_name, url, which_party)

   noko = noko_for(url)

   #reset vars for each MP
   electorate_name = nil
   elected_date = " "
   
   puts "\nName: " + mp_name.to_s

   # Iterate over the rows of general info and try and
   # identify specific information
   info_rows = noko.css('table table table tr')
   info_rows.each do |row|

     #Reset variables for each row
     label = nil, cell_content = nil
     info_cells = row.css('td[class*="boxedtext"]')
     next if info_cells[0] == nil  # ignore lines with no "boxedtext"

     label = info_cells[0].text.strip 
     cell_content = info_cells[1].text.strip 

     # Check if line contains Electorate
     if label.to_s == "Electorate" 
        electorate_name = cell_content
     end
 

     # Check if line contains start date
     if label.to_s == "Date elected" 
        elected_date_string = cell_content
        elected_date = Time.parse(elected_date_string).strftime("%d.%m.%Y")
     end

   end #end row interation

  #conditional assign: if electorate hasn't been found, set to " "
  electorate_name ||= " "

   data = { 
     member_count: url.to_s.split("=").last,
     id__saparl: url.to_s.split("=").last,
     full_name: mp_name,
     division: electorate_name,
     state: 'SA',
     start_date: elected_date,
     election_type: ' ',
     end_date: '', 
     reason_left: 'still_in_office',
     party: which_party,
   }

   puts data.to_s

   data[:image] = URI.join(url, data[:image]).to_s unless data[:image].to_s.empty?

  ScraperWiki.save_sqlite([:member_count], data)

end

scrape_list(sa_mps_url)

#Testing: just try it on one page first... 
#scrape_person('Frances Bedford', 'https://www2.parliament.sa.gov.au/Internet/DesktopModules/MemberDrill.aspx?pid=543')
