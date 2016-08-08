## Put comments here that give an overall description of what your
## functions do

## makeCacheMatrix stores a given matrix X in memory.
## cacheSolve shows the inverse of a matrix that is still in memory or calculates and displays the inverse matrix.

## Write a short comment describing this function

## The makeCacheMatrix function will take a matrix as a parameter, and using R language's scoping rules, 
## it will store the matrix in memory.

makeCacheMatrix <- function(X = matrix()) 
{
  i <- NULL
  set <- function(y)
    {
    x <<- y
    inverse <<- NULL
    }
  get <- function() x
  setinverse <- function(inverse) i <<- inverse
  getinverse <- function() i
  list(set=set, get=get, setinverse=setinverse, getinverse=getinverse)
}

## Write a short comment describing this function

## The cacheSolve function will take the matrix as a parameter and obtain its inverse.

cacheSolve <- function(x, ...) 
{
  i <- x$getinverse()
  if(!is.null(i)){
    message("Getting cached matrix data")
    return(i)
  }
  data <- x$get()
  i <- solve(data, ...)
  x$setinverse(i)
  i
}

##An example with an square matrix, taken from the normal distribution.
x <- matrix(rnorm(25), nrow = 5)
mcx <- makeCacheMatrix(X)
mcx$get()
cacheSolve(mcx)
cacheSolve(mcx)
invx <- cacheSolve(mcx)