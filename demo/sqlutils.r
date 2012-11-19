require(sqlutils)
require(RSQLite)
require(retention)

data(students)
students$CreatedDate = as.integer(as.Date(students$CreatedDate), origin='2000-01-01')
m <- dbDriver("SQLite")
tmpfile <- tempfile('students.db', fileext='.db')
conn <- dbConnect(m, dbname=tmpfile)
dbWriteTable(conn, "students", students[!is.na(students$CreatedDate),])

#This will return the path(s) where query files will be loaded from
sqlPaths()

#List of available queries
getQueries()

#Return documentation of the queries
sqldoc('StudentSummary')
sqldoc('StudentsInRange')

#Execute the query
q1 <- execQuery('StudentSummary', connection=conn)
head(q1)
#Can always get the SQL statement to examine
getSQL('StudentSummary')

q2 <- execQuery('StudentsInRange', connection=conn)
head(q2)
#This query that has parameters will have their values replaced.
getSQL('StudentsInRange')

#Cache query
fn <- tempfile(fileext='.rda')
q3 <- cacheQuery('StudentSummary', filename=fn, connection=conn)
names(q4); nrow(q3)

#Since this will read from the cache, we don't need to specify the connection.
q4 <- cacheQuery('StudentSummary', filename=fn) 
names(q4); nrow(q4)

#Clean-up our session
dbDisconnect(conn)
file.remove(tmpfile)
