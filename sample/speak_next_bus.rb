require 'onebusaway'
require 'osax' # gem install rb-appscript

api_key = ARGV.shift
stop    = ARGV.shift || 3500
agency  = ARGV.shift || 1 # King County Metro

o = Onebusaway.new api_key

arr_devs = o.arrivals_and_departures_for_stop agency, stop

upcoming = arr_devs.select do |arr_dev|
  arr_dev.route_id == 60
end.map do |arr_dev|
  arr_dev.minutes_from_now
end

def minutes offset
  relative = offset.abs

  minutes = "#{relative} minute"
  minutes << "s" if relative > 1

  minutes << " ago" if offset < 0

  minutes
end

text = if upcoming.first > 0 then
         "The next bus is in #{minutes upcoming.first}"
       else
         "The bus left #{minutes upcoming.first}"
       end

OSAX.osax.say text

