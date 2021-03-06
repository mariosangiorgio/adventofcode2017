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

hash <- function(input){
	input <- c(as.integer(charToRaw(input)), c(17, 31, 73, 47, 23))
	s <- seq(0,255)
	c <- 0
	skip <- 0
	for(iteration in seq(1,64)){
		for (i in seq_along(input)){	
			s <- shuffle(s, c, input[i])
			c <- (c + skip + input[i]) %% length(s) 
			skip <- skip + 1
		}	
	}
	paste(as.raw(lapply(seq(0,15), function(x){Reduce(bitwXor,s[seq(1+16*x,16*(x+1))])})), collapse="")
}

input <- scan('/Users/mariosangiorgio/Downloads/input', what="")
print(hash(input))

# Input for day 14
lines <- lapply(seq(0,127), function(i){hash(paste("hxtvlmkl-", i, sep=""))})
fileConn<-file("/Users/mariosangiorgio/Downloads/output")
writeLines(Reduce(function(a,b){paste(a,b,"\n",sep="")},lines), fileConn)
close(fileConn)
