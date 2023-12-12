lines = File.readlines("input")

def predict_previous(history)
  if history.all?(&:zero?)
    return 0
  end
  
  next_history = (0..history.count-2).map {|i| history[i+1] - history[i]}

  prediction = predict_next(next_history)

  return history.first - prediction
end

history_values = lines.map {|l| l.strip.split(" ").map(&:to_i) }

retval = history_values.map {|history| predict_next(history) }.sum

puts retval
