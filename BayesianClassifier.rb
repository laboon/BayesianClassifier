require_relative 'Classifier'

# Execution starts here

puts "Naive Bayesian Classifier"

c = Classifier.new
print "Enter training data file > "
tdf = readline
c.train tdf

