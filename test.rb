require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'json'

listings = Nokogiri::HTML(open("http://streeteasy.com/nyc/sales/soho-manhattan/status:open?sort_by=price_desc"))

class Scraper
  
  def initialize(type, num)
    @type = type
    @url = "http://streeteasy.com/nyc/#{type}/soho-manhattan/status:open?page=#{num}&sort_by=price_desc"
    @num = num
    @nodes = Nokogiri::HTML(open(@url + @type + @num))  
  end

  def summary(filename)

    listing_data = @nodes
    
    listings = listing_data.css('div.unsponsored div.item.compact.listing') 
       
      listing_hashes = listings.map {|x| 
         type = "#{@type}"
         address = x.css('div.body h3 a').text
         unit = x.css('div.body h3 a').text.gsub!(/.*?(?=#)/im, "")
         url = x.css('div.item_inner div.body h3 a').text
         price = x.css('h3 span').text 

        {
          :type => type,
          :address => address,
          :unit => unit,
          :url => url,
          :price => price,
        }
      }

    File.open("public/#{filename}","w") do |f|
     f.write(JSON.pretty_generate(listing_hashes))
    end   
   end
end 
  
rentals = Scraper.new("rentals", "1")
sales = Scraper.new("sales", "1")
rentals_2 = Scraper.new("rentals", "2")
sales_2 = Scraper.new("sales", "2")
rentals.summary("rental_1")
rentals_2.summary("rental_2")
sales.summary("sale_1") 
sales_2.summary("sale_2")
 

