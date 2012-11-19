#' Students enrolled within the given date range.
#' 
#' @param startDate the start of the date range to return students.
#' @default startDate format(Sys.Date(), '%Y-01-01')
#' @param endDate the end of the date range to return students.
#' @default endDate format(Sys.Date(), '%Y-%m-%d')
#' @return CreatedDate the date the row was added to the warehouse data.
#' @return StudentId the student id.
SELECT * 
FROM students 
WHERE CreatedDate >= ':startDate:' AND CreatedDate <= ':endDate:'
