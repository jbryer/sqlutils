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
m <- dbDriver("SQLite")
conn <- dbConnect(m, dbname='students.db')
dbWriteTable(conn, "students", students[!is.na(students$CreatedDate),])
q1 <- execQuery('StudentSummary', connection=conn)
head(q1)

#Excelsior test
sqlPaths(paste(oDrive, '/R/ecir/data', sep=''))
getQueries()
sqldoc('WarehouseDataRange')



