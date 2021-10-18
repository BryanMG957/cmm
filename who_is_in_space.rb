require "httparty"
require "json"

class Astronaut
  attr_accessor :craft, :name

  @@astronauts = Array.new

  def initialize(craft, name)
    @craft = craft
    @name = name
    @@astronauts << self
  end

  def self.fetch_astronauts
    #API Call
    response = HTTParty.get("http://api.open-notify.org/astros.json")

    parsed_response = JSON.parse(response.body)

    people_in_space = parsed_response["people"]

    #Create an object for each person in space
    people_in_space.each do |person|
      person = Astronaut.new(person["craft"], person["name"])
    end
  end

  #NOT attempting the challenge with this style of formatting (as per instructions in email) it should be dynamics
  #TODO improve formatting to use the actual lenght of the name.
  #TODO
  def self.to_table(astronauts)
    table_string = ""
    table_string += "Name".ljust(18) + " | Craft".ljust(15) + "\n"
    table_string += "-".ljust(18, "-") + "-".ljust(15, "-") + "\n"
    astronauts.each { |astronaut|
      table_string += "#{astronaut.name.ljust(18)} | #{astronaut.craft.ljust(15)} \n"
    }

    table_string
  end

  def self.all_astronauts
    fetch_astronauts()
    to_table(@@astronauts)
  end
end

astronauts = Astronaut.all_astronauts()

puts astronauts

puts "\n*************** TEST ***************"
puts ""

astronaut1 = Astronaut.new("ISS", "Nelson Piquet")
astronaut2 = Astronaut.new("ISS", "Megan McArthur")
astronaut3 = Astronaut.new("Shenzhou 13", "Wang Yaping")

test_astronauts = [astronaut1, astronaut2, astronaut3]

expected_output = "Name               | Craft       
---------------------------------
Nelson Piquet      | ISS             
Megan McArthur     | ISS             
Wang Yaping        | Shenzhou 13     
"

def test_table_output(astronauts, expected_output)
  if expected_output == Astronaut.to_table(astronauts)
    "Output matches"
  else
    "Unexpected Output"
  end
end

puts test_table_output(test_astronauts, expected_output)
