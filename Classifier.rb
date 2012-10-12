class Classifier

  def initialize
    @pos_count = Hash.new
    @neg_count = Hash.new
  end

  def incr_word_instance(word, polarity)
    
    word.downcase!
    word.gsub!(/[^0-9a-z]/i, '')
    # puts "Putting " + word + "..."
    case polarity
    when :positive
      if (@pos_count.include?(word))
        @pos_count[word] = @pos_count[word] + 1
        # puts "Pos[" + word + "] = " + @pos_count[word].to_s
      else
        @pos_count[word] = 1
        # puts "Added positive: " + word
      end
    when :negative
      if (@neg_count.include?(word))
        @neg_count[word] = @neg_count[word] + 1
      else
        @neg_count[word] = 1
      end
    else
      puts "Polarity should be :positive or :negative"
    end
  end

  def calc_phrase_vals(phrase, polarity)
    split_phrase = phrase.split
    split_phrase.each { |word| incr_word_instance(word, polarity)}
  end

  def read_in_file(file)
    file_reader = File.new(file, "r")
    cur_status = :positive
    while (line = file_reader.gets)
      line.chomp!
      if (line.eql?("*"))
          puts "Switching to neg"
          cur_status = :negative
      else
        puts "Calculating " + line
        calc_phrase_vals(line, cur_status)
      end
    end
    
  end
  
  def train(training_data_file)
    print "Beginning training"
    read_in_file(training_data_file.chomp)
    print ".done!"
  end
  
end





