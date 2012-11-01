#' Provides counts of all records by month.
#' @return a summary of students by month.
SELECT CreatedDate, count(StudentId) 
FROM students
GROUP BY CreatedDate
ORDER BY CreatedDate
