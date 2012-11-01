require(devtools)
setwd("~/Dropbox/Projects/")

## Build functions
document('sqlutils')
check_doc('sqlutils')
install('sqlutils')
check('sqlutils')

## Test functions
require(sqlutils)
sqlPaths()
getQueries()
getParameters('StudentsInRange')
getParameters('StudentSummary')
sqldoc('StudentsInRange')
sqldoc('StudentSummary')
getSQL('StudentsInRange')
getSQL('StudentsInRange', startDate='2012-01-01', endDate='2012-12-31')
getSQL('StudentSummary')

sqlPaths(path='~/Dropbox/Excelsior/Queries')
getQueries()

require(RSQLite)
require(retention)
data(students)
data(graduates)
m <- dbDriver("SQLite")
dbfile <- 'sqlutils/data/students.db'
conn <- dbConnect(m, dbname=dbfile)
dbWriteTable(conn, "students", students[!is.na(students$CreatedDate) & 
							students$CreatedDate > as.Date('2010-07-01'),])
dbWriteTable(conn, "graduates", graduates[!is.na(graduates$GraduationDate) & 
							graduates$GraduationDate > as.Date('2010-07-01'),])

execQuery('StudentSummary', connection=conn)
