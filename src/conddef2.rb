require 'csv'
require 'json'

csv_data = CSV.read(ARGV[0], headers: true)

a = [];
t = 0
b = 0
c = 0
  csv_data.each do |data|
    x = {};
#    puts "var ", data["CONDIITIONSYMBOL"], data["VALUE"]          
    if (data["CONDITIONSYMBOL"] != nil && data["VALUE"] != nil) then
      if (data["KIND"] == "TECH") then
         puts "#define " + data["CONDITIONSYMBOL"] + " " + data["VALUE"] + ""
      elsif (data["KIND"] == "BUILDING") then
         puts "#define " + data["CONDITIONSYMBOL"] + " " + data["VALUE"] + ""        
      elsif (data["KIND"] == "CIV") then
         puts "#define " + data["CONDITIONSYMBOL"] + " " + data["VALUE"] + ""        
      else
         puts "#define " + data["CONDITIONSYMBOL"] + " " + data["VALUE"]
      end
    end
    data.each{|key,val| if (key) then x[key] = val; end }
    a.push(x);
  end
