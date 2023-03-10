require './spec/spec_helper'
require './lib/braille_writer'
require './lib/dictionary'
require './lib/english_writer'

describe 'englishwriter' do
  before(:all) do

    @input_file = File.open('./braille_test.txt')
    @output_file = './original_message_test.txt'
    @english_writer = EnglishWriter.new(@input_file, @output_file)
    @dictionary = Dictionary.new
    @output_string = ""
  end

  it "exists" do
    expect(@english_writer).to be_an_instance_of(EnglishWriter)
  end

  it "can read an input file and create an arraay containing the lines" do
    expect(@english_writer.create_line_array(@input_file)).to eq(["0.0.00", "..0...", "......"])
  end

  it "can extract the first braille character" do
    string_array = ["0.0.00", "..0...", "......"]
    expect(@english_writer.build_braille_character_string(string_array)).to eq("0.....")
  end

  it "can convert a braille character string to its english character equivalent" do
    braille_char_string = "0....."
    expect(@english_writer.convert_to_eng_char(braille_char_string)).to eq("a")
  end

  it "can add a converted character to the output string" do
    char = 'a'
    @english_writer.add_to_output(char, @output_string)
    expect(@output_string).to eq("a") 
  end

  it "can write the converted string to a file" do
    output_string = 'a'
    @english_writer.write_english(@output_file, output_string)
    expect(File.read(@output_file)).to eq('a')
  end

  it "can count the number of characters in a file" do
    file = './message.txt'
    expect(@english_writer.count_chars(file)).to eq(6)
  end

  it "can return a message with the character count interpolated" do
    chars = 5
    expect(@english_writer.return_char_count(chars)).to eq("Created original_message.txt containing 5 characters")
  end

  it "can take braille text from a file, convert it to english text and output it to another file" do
    expect(@english_writer.count_chars(@output_file)).to eq(1)
    @english_writer.run
    expect(@english_writer.count_chars(@output_file)).to eq(3)
  end

  it "can consolidate wrapped braille lines into a single array of top, middle and low characters" do
    unconsolidated_array = ['a','b','c','a','b','c','a','b','c']
    expect(@english_writer.consolidate_strings(unconsolidated_array)).to eq(["aaa", "bbb", "ccc"])
  end
end

