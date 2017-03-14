require 'fileutils'

class Point
  attr_reader :x, :z

  def initialize(x, z)
    @x = x
    @z = z
  end

  def to_s
    "(#{x}, #{z})"
  end
end

def move(origin_p1, origin_p2, moved_p1)
  offset_x = moved_p1.x - origin_p1.x
  offset_z = moved_p1.z - origin_p1.z
  regions = Dir["r.*.*.mca"]

  location = 'YiShan'
  FileUtils.rm_rf(location) if File.directory?(location)
  Dir.mkdir(location)

  moved_counter = 0

  regions.each do |region|
    # TODO: Using Regex is better
    data = region.split('.')
    pos_x = data[1].to_i
    pos_z = data[2].to_i
    range_x = [origin_p1.x, origin_p2.x]
    range_z = [origin_p1.z, origin_p2.z]

    unless pos_x.between?(range_x.min, range_x.max) && pos_z.between?(range_z.min, range_z.max)
      puts "#{region} x"
      next
    end

    new_pos_x = pos_x + offset_x
    new_pos_z = pos_z + offset_z

    new_file_name = "r.#{new_pos_x}.#{new_pos_z}.mca"

    puts "#{region} -> #{new_file_name}"
    FileUtils::cp(region, "#{location}/#{new_file_name}")
    moved_counter += 1
  end

  puts "Moved #{moved_counter} regions"
end


if ARGV.size < 6
  puts "Wrong size of Arguments"
  return
end

origin_p1 = Point.new(ARGV[0].to_i, ARGV[1].to_i)
origin_p2 = Point.new(ARGV[2].to_i, ARGV[3].to_i)
moved_p1 = Point.new(ARGV[4].to_i, ARGV[5].to_i)

move(origin_p1, origin_p2, moved_p1)