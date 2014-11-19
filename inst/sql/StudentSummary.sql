--' Provides counts of all records by month.
--' @return CreatedDate the warehouse date.
--' @return count the number of students enrolled as of the corresponding CreatedDate
SELECT CreatedDate, count(StudentId) AS count
FROM students
GROUP BY CreatedDate
ORDER BY CreatedDate
