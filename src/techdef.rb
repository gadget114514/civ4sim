require 'csv'
require 'json'

csv_data = CSV.read(ARGV[0], headers: true)

a = [];
t = 0
b = 0
c = 0
  csv_data.each do |data|
    if (data["CONDITIONSYMBOL"] != nil && data["VALUE"] != nil) then

name=data["NAME"]
kind=data["KIND"]
conditionsymbol=data["CONDITIONSYMBOL"]
value=data["VALUE"]
maxnum=data["MAXNUM"]
era=data["ERA"]
o=data["O"]
startera=data["STARTERA"]
autobuilld=data["AUTOBUILLD"]
regardas=data["REGARDAS"]
civuniq=data["CIVUNIQ"]
prereq1=data["PREREQ1"]
prereq2a=data["PREREQ2A"]
prereq2b=data["PREREQ2B"]
prereq3c=data["PREREQ3C"]
prereq3x=data["PREREQ3X"]
precost1t=data["PRECOST1T"]
precost1c=data["PRECOST1C"]
precost2t=data["PRECOST2T"]
precost2c=data["PRECOST2C"]
postcost1t=data["POSTCOST1T"]
postcost1c=data["POSTCOST1C"]
productionbonus1t=data["PRODUCTIONBONUS1T"]
productionbonus1x=data["PRODUCTIONBONUS1X"]
productionbonus2t=data["PRODUCTIONBONUS2T"]
productionbonus2x=data["PRODUCTIONBONUS2X"]
productionbonus3t=data["PRODUCTIONBONUS3T"]
productionbonus3x=data["PRODUCTIONBONUS3X"]
productionbonus4t=data["PRODUCTIONBONUS4T"]
obsoletedby=data["OBSOLETEDBY"]
productionbonus4x=data["PRODUCTIONBONUS4X"]
effect1c=data["EFFECT1C"]
effect1t=data["EFFECT1T"]
effect1x=data["EFFECT1X"]
effect2c=data["EFFECT2C"]
effect2t=data["EFFECT2T"]
effect2x=data["EFFECT2X"]
effect2c=data["EFFECT2C"]
effect3t=data["EFFECT3T"]
effect3x=data["EFFECT3X"]
effect4c=data["EFFECT4C"]
effect4t=data["EFFECT4T"]
effect4x=data["EFFECT4X"]
effect5c=data["EFFECT5C"]
effect5t=data["EFFECT5T"]
effect5x=data["EFFECT5X"]
effect6c=data["EFFECT6C"]
effect6t=data["EFFECT6T"]
effect6x=data["EFFECT6X"]
effect7t=data["EFFECT7T"]
effect7x=data["EFFECT7X"]

if prereq1==nil then
  prereq1="0"
end
if prereq2a==nil  then
  prereq2a="0"
end
if prereq2b==nil  then
  prereq2b="0"
end
if prereq3c==nil  then
  prereq3c="0"
end
if prereq3x==nil  then
  prereq3x="0"
end


s=""
if effect1t==nil then
  s="[]"
elsif effect2t==nil then
  s="[#{effect1t},#{effect1x}]"
elsif effect3t==nil then
  s="[#{effect1t},#{effect1x},#{effect2t},#{effect2x}]"  
elsif effect4t==nil then
  s="[#{effect1t},#{effect1x},#{effect2t},#{effect2x},#{effect3t},#{effect3x}]"    
elsif effect5t==nil then
  s="[#{effect1t},#{effect1x},#{effect2t},#{effect2x},#{effect3t},#{effect3x},#{effect4t},#{effect4x}]"      
elsif effect6t==nil then
  s="[#{effect1t},#{effect1x},#{effect2t},#{effect2x},#{effect3t},#{effect3x},#{effect4t},#{effect4x},#{effect5t},#{effect5x}]"        
elsif effect7t==nil then
  s="[#{effect1t},#{effect1x},#{effect2t},#{effect2x},#{effect3t},#{effect3x},#{effect4t},#{effect4x},#{effect5t},#{effect5x},#{effect6t},#{effect6x}]"        
elsif effect7t!=nil then
  s="[#{effect1t},#{effect1x},#{effect2t},#{effect2x},#{effect3t},#{effect3x},#{effect4t},#{effect4x},#{effect5t},#{effect5x},#{effect6t},#{effect6x},#{effect7t},#{effect7x}]"        
end  
precost="[]"
if precost1t!=nil then
  precost="[#{precost1t},#{precost1c}]"
end
postcost="[]"
if postcost1t!=nil then
  postcost="[#{postcost1t},#{postcost1c}]"
end
productionbonus="[]"
if productionbonus1t!=nil then
  productionbonus="[#{productionbonus1t},#{productionbonus1x}]"
end
  
      if (data["KIND"] == "TECH") then
         printf "cv.defineTech(#{conditionsymbol},\"#{name}\",\"#{name}\",[#{prereq1},#{prereq2a},#{prereq2b},#{prereq3c},#{prereq3x}],#{precost},#{postcost},#{productionbonus},#{s})\n";
      elsif (data["KIND"] == "BUILDING") then
         printf "cv.defineBuilding(#{conditionsymbol},\"#{name}\",\"#{name}\",[#{prereq1},#{prereq2a},#{prereq2b},#{prereq3c},#{prereq3x}],#{precost},#{postcost},#{productionbonus},#{s})\n";
      elsif (data["KIND"] == "CIV") then

      else

      end
    end
#    data.each{|key,val| if (key) then x[key] = val; end }
#    a.push(x);
  end



