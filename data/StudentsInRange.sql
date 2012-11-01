#' Students enrolled within the given date range.
#' 
#' @param startDate the start of the date range to return students.
#' @default startDate 2011-07-01
#' @param endDate the end of the date range to return students.
#' @default endDate 2012-08-01
#' @return all students
SELECT * 
FROM students 
WHERE CreatedDate >= ':startDate:' AND CreatedDate <= ':endDate:'
