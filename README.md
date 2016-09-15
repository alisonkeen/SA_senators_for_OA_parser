
The data in this scraper is incomplete - actual election type and past MPs aren't included in the database yet. (sorry). Maybe one day... or you could write it if you want! 

This parser repeats the scrape of the MP list, and then reads out information for upper house MPs only, into the fields expected by OpenAustralia's parser.

Those two csv files need to be generated separately to get their own URLs, so that forked openaustralia parsers can pull them into a database. 

scraper #1: List of MPS - https://morph.io/alisonkeen/SA\_MHRS\_for\_OA\_input
fields {id, saparl ID, full name}
destination: /var/www/openaustralia/openaustralia-parser/data/people.csv

scraper #2: List of MHRs - https://morph.io/alisonkeen/SA\_members\_for\_OA\_parser
fields {id, id2, Name, Electorate, State/Territory(?), Start date, Election type, End date, reason, Most recent party}
destination: /var/www/openaustralia/openaustralia-parser/data/representatives.csv

scraper #3: List of Senators - https://morph.io/alisonkeen/SA\_senators\_for\_OA\_parser
fields {id, id2, Name, Electorate, State/Territory(?), Start date, Election type, End date, reason, Most recent party}
destination: /var/www/openaustralia/openaustralia-parser/data/senators.csv

Ruby script to read these three .csv files into OpenAustralia: see https://github.com/alisonkeen/openaustralia-parser-sandbox/import-data-from-morph.rb


This is a scraper that runs on [Morph](https://morph.io). To get started [see the documentation](https://morph.io/documentation)
