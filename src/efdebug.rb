require 'csv'
require 'json'

csv_data = CSV.read(ARGV[0], headers: true)

a = [];
puts "class Estr {"
puts "construct new() {"
puts "_debug = {}"
puts "_debugi = {}"
csv_data.each do |data|
    x = {};
    if (data["EFFECTSYMBOL"]) then
      puts " _debug[\"" + data["EFFECTSYMBOL"] + "\"]=" + data["VALUE"]
    end
    if (data["EFFECTSYMBOL"]) then
      puts " _debugi[" + data["VALUE"]+ "]=" + "\"" + data["EFFECTSYMBOL"]  + "\""
    end
    data.each{|key,val| if (key) then x[key] = val; end }
    a.push(x);
end
  puts "}"  
puts "debug{_debug}"
puts "debugi{_debugi}"
  puts "}"
