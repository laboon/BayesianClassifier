class Classifier

  def initialize
    @pos_count = Hash.new
    @neg_count = Hash.new
    
    @pos_prob = Hash.new
    @neg_prob = Hash.new
    @pos_spec_prob = Hash.new
    @neg_spec_prob = Hash.new
    @tot_prob = Hash.new
    
    @tot_pos_words = 0
    @tot_neg_words = 0
    @tot_words = 0
  end

  def incr_word_instance(word, polarity)
    
    word.downcase!
    word.gsub!(/[^0-9a-z]/i, '')
    @tot_words += 1
    
    # puts "Putting " + word + "..."
    case polarity
    when :positive
      @tot_pos_words += 1
      if (@pos_count.include?(word))
        @pos_count[word] = @pos_count[word] + 1
        # puts "Pos[" + word + "] = " + @pos_count[word].to_s
      else
        @pos_count[word] = 1
        # puts "Added positive: " + word
      end
    when :negative
      @tot_neg_words += 1
      
      if (@neg_count.include?(word))
        @neg_count[word] = @neg_count[word] + 1
      else
        @neg_count[word] = 1
      end
    else
      puts "Polarity should be :positive or :negative"
    end
    
  end

  def calc_probability
    # Calculate probability a word is in a positive or negative
    @pos_count.each { |word, count| @pos_prob[word] = @pos_count[word].to_f / @tot_words }
    @neg_count.each { |word, count| @neg_prob[word] = @neg_count[word].to_f / @tot_words }
    
    @pos_count.each { |word, count| @pos_spec_prob[word] = @pos_count[word].to_f / @tot_pos_words }
    @neg_count.each { |word, count| @neg_spec_prob[word] = @neg_count[word].to_f / @tot_neg_words }
  end

  def calc_phrase_vals(phrase, polarity)
    
    split_phrase = phrase.split
    split_phrase.each { |word| incr_word_instance(word, polarity)}
    # @tot_words = @tot_pos_words + @tot_neg_words
    puts @tot_words.to_s + ": " + @tot_pos_words.to_s + " + " + @tot_neg_words.to_s
    
    
  end

  def print_probs
    puts "POSITIVE"
    @pos_prob.each { |word, prob| puts word + ": " + prob.to_s }
    puts "NEGATIVE"
    @neg_prob.each { |word, prob| puts word + ": " + prob.to_s }
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
    
    calc_probability
    print_probs
  
  end
  
  
  def train(training_data_file)
    puts "Beginning training..."
    read_in_file(training_data_file.chomp)
    puts "...done!"
  end
  
  def strip_null_elements(words, polarity)
    cleared_words = []
    case polarity
    when :positive
      words.each { |word|
        if @pos_prob.include?(word)
          cleared_words.push(word)  
        end
      }
    when :negative
      words.each { |word|
        if @neg_prob.include?(word)
          cleared_words.push(word)  
        end
      }
    end
    return cleared_words
  end
  
  def bayes_calc(phrase, polarity)
    phrase.downcase!
    phrase.gsub!(/[^0-9a-z]/i, ' ')
    words = phrase.split
    # Ignore words that we've never seen before
    words = strip_null_elements(words, polarity)
    # multiplicative identity
    @numerator = 1.0
    @denominator = 1.0
    case polarity
    when :positive
      words.each { |word| @numerator *= @pos_spec_prob[word]}  
    when :negative
      words.each { |word| @numerator *= @neg_spec_prob[word]}  
    end
    @numerator *= 0.5 # probability that it is pos or neg
    
    case polarity
    when :positive
      words.each { |word| @denominator *= @pos_prob[word]}  
    when :negative
      words.each { |word| @denominator *= @neg_prob[word]}  
    end
    puts "? " + @numerator.to_s + " / " + @denominator.to_s
    prob_pol = @numerator / @denominator
    return prob_pol
  end
  
end





