#' Students enrolled within the given date range.
#' 
#' @param startDate the start of the date range to return students.
#' @default startDate '2012-07-01'
#' @param endDate the end of the date range to return students.
#' @default endDate toupper(format(Sys.Date()-14, '15-%b-%Y'))
#' @return all students
SELECT * 
FROM students 
WHERE CreatedDate >= ':startDate:' AND CreatedDate <= ':endDate:'
