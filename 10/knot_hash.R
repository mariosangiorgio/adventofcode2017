shifter <- function(x, n) {
  if (n == 0) x else c(tail(x, -n), head(x, n))
}
shuffle <- function(l, offset, size){	
	if(size == 0) l
	else{	
	shifted <- shifter(l, offset)
	shuffled_head <- rev(head(shifted, size))	
	shifter(c(shuffled_head, tail(shifted, -size)), -offset)			
	}
}

input <- scan('/Users/mariosangiorgio/Downloads/input', what=integer(), sep=",")
s <- seq(0,255)
c <- 0
for (i in seq_along(input)){	
	s <- shuffle(s, c, input[i])
	c <- (c + (i-1) + input[i]) %% length(s) 
}
print(s[1]*s[2])