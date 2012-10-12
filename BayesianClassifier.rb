require './Classifier'

def print_results(pos_prob, neg_prob)
  print "\nPositive probability: "
  puts pos_prob
  print "\nNegative probability: "
  puts neg_prob
  if (pos_prob == neg_prob)
    puts "Not sure of polarity"
  elsif (pos_prob > neg_prob)
    puts "Positive sentiment"
  else
    puts "Negative sentiment"
  end
end

# Execution starts here

puts "Naive Bayesian Classifier"

c = Classifier.new
print "Enter training data file > "
tdf = readline
c.train tdf
print "Classifier trained!"
while (true)
  print "Enter phrase (Ctrl-C to quit) > "
  phrase = readline.chomp
  pos_prob = c.bayes_calc(phase, :positive).to_f
  neg_prob = c.bayes_calc(phase, :negative).to_f
  print_results(pos_prob, neg_prob)
  
end

