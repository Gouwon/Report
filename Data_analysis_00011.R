## This file is 'fibonacci.R'.
# 1, 1, 2, 3, 5, 8


while(TRUE) {
  input_value = as.integer(readline(prompt = "Input the number: "))
  if (input_value < 0) break
  
  x = 1
  y = 1
  n = input_value - 2
  result = paste(x, y)
  if (input_value == 0)
    print("The fibonacci sum of 0 is 0")
  else if (input_value == 1)
    result = paste(x)
  else if (input_value == 2)
    result = paste(x, y)
  else {
    for (i in 1:n) {
        z = x + y
        result = paste(result, z)
        print(result)
        x = y
        y = z 
    }
  }
  print(paste("The factorial of", input_value, "is", result))
}

