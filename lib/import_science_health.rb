require 'cskit'
require 'cskit/science_health'

include CSKit::Readers

SENTENCE_TERMINATOR_REGEX = /(\.\"|[\?\.])/

volume = CSKit.get_volume(:science_health)
reader = ScienceHealthReader.new(volume)
sentence = ""
sentence_index = 0

reader.each_line(1, "vi") do |line, line_number, page_number|
  sentence += line.text
  sentence += " " unless sentence =~ /.*\-\z/

  if match = sentence.match(SENTENCE_TERMINATOR_REGEX)
    sentence_end = match.offset(0).first + match.captures.first.size
    found = sentence[0..sentence_end].strip

    Phrase.create(
      key: found,
      sort_key: sentence_index
    )

    sentence_index += 1
    sentence = sentence[sentence_end + 1..-1] || ""
  end
end