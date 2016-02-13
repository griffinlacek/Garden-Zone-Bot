#Method to remove quotations around city names from CSV file
def remove_quotations(str)
  if str.start_with?('"')
    str = str.slice(1..-1)
  end
  if str.end_with?('"')
    str = str.slice(0..-2)
  end
end

def get_zone(zip_code)

  file = File.open("hardiness_zones.csv", "r")

  file.each do |line| 
    if line =~ /#{zip_code}/
      line_info = line.split(',')
      line_zip = line_info[0]
      zone = line_info[1]
      city = line_info[2]
      state = line_info[3]
    
      remove_quotations(city)
    
      return "The USDA hardiness zone for #{city}, #{state} #{line_zip} is : #{zone}"
  
    end
  end

  return "That zip code is not in my database!"
  
end
