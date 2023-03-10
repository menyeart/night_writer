require './lib/dictionary'

class EnglishWriter < Dictionary
  attr_reader :input_file, :output_file, :output_string

  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
    @output_string = ""
    @character_count = 0
  end

  def run
    line_array = create_line_array(@input_file)
    new_line_array = consolidate_strings(line_array)
    until new_line_array == ["","",""]
      braille_string = build_braille_character_string(new_line_array)
      eng_string = convert_to_eng_char(braille_string)
      add_to_output(eng_string, @output_string)
    end
    write_english(@output_file, @output_string)
    puts return_char_count(count_chars(@output_file))
  end

  def create_line_array(file)
    File.readlines(file).map do |line| 
      line.delete("\n")
    end
  end

  def build_braille_character_string(line_array)
    braille_string = ''
    line_array.each do |line|
      braille_string.concat(line[0,2])
      line.slice!(0,2)
    end
    braille_string
  end

  def convert_to_eng_char(string)
    self.braille_to_english[string]
  end

  def add_to_output(string, output_string)
    output_string.concat(string)
  end
    
  def write_english(file, output_string)
    file = File.open(file, "w")
    file.write(output_string)
    file.close
  end

  def count_chars(file)
    @character_count = File.readlines(file).join.length
  end

  def return_char_count(chars)
    "Created original_message.txt containing #{chars} characters"
  end

  def consolidate_strings(array_of_strings)
    new_line_array = ['', '', '']
    counter = 1
    array_of_strings.each do |string|
      if counter == 1
        new_line_array[0].concat(string)
      elsif counter == 2
        new_line_array[1].concat(string)
      else
        new_line_array[2].concat(string)
      end
      if counter == 3
        counter = 0
      end
      counter += 1
    end
    new_line_array
  end


end
