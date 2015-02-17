require 'rubygems'
require 'mixpanel_client'
require 'pp'
require 'json'
require 'csv'
 
config = {api_key: 'changeme', api_secret: 'changeme'}
client = Mixpanel::Client.new(config)
 
events = client.request('export', {  #this is your Mixpanel API endpoint.  In this case 'export'
  from_date:    '2015-01-01',
  to_date:    '2015-02-15',
})
 
#Option to save the json output to a file within this directory
File.open("events.json","w+") do |f|
  f.puts pp events
end
 
#Output data to CSV
CSV.open("events.csv", "wb") do |csv|
  columns = %w(event distinct_id)  
  csv << columns #put columns into csv
  events.each do |event| #looping over each event
    row = []
    row[0] = event["event"]
    properties = event["properties"] #holds hash of event properties
    properties.each_pair do |property_name, value| #loop over each property
      property_name = property_name.sub("$", "")
      index = columns.index(property_name)
      next if index.nil?
      raise "Couldn't find column #{property_name}" if index.nil?
      row[index] = value
    end
    csv << row
  end
end
