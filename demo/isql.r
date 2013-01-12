require(sqlutils)
require(RSQLite)
require(retention)

data(students)
students$CreatedDate = as.character(students$CreatedDate)
m <- dbDriver("SQLite")
tmpfile <- tempfile('students.db', fileext='.db')
conn <- dbConnect(m, dbname=tmpfile)
dbWriteTable(conn, "students", students[!is.na(students$CreatedDate),])

hist <- isql(conn=conn, sql=getSQL('StudentSummary'))
names(hist)
hist[['commands']]
hist[['sql']]
