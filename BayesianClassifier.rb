require './Classifier'

def print_results(pos_prob, neg_prob)
  
  if (pos_prob == neg_prob)
    puts "\n *** UNKNOWN sentiment polarity ***"
  elsif (pos_prob > neg_prob)
    puts "\n *** Positive sentiment ***"
  else
    puts "\n *** Negative sentiment ***"
  end
end

# Execution starts here

puts "Naive Bayesian Classifier"

c = Classifier.new
print "Enter training data file > "
tdf = readline
c.train tdf
puts "Classifier trained!"
while (true)
  print "Enter phrase (Ctrl-C to quit) > "
  phrase = readline.chomp
  pos_prob = c.bayes_calc(phrase, :positive).to_f
  neg_prob = c.bayes_calc(phrase, :negative).to_f
  print_results(pos_prob, neg_prob)
  
end

