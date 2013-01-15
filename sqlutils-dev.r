require(devtools)
setwd("~/Dropbox/Projects/")

## Build functions
document('sqlutils')
check_doc('sqlutils')
install('sqlutils')
check('sqlutils')

release('sqlutils')

require(sqlutils)
vignette('DataDictionary')


##### Data setup ###############################################################
# Get a subset of the students from the retention package
require(RSQLite)
data(students)
students <- students[!is.na(students$CreatedDate),]
students$CreatedDate = as.character(students$CreatedDate)
students <- students[students$CreatedDate > '2011-07-01',]
students <- students[students$Level == 'Associate',]
sqlfile <- 'sqlutils/data/students.db'
if(file.exists(sqlfile)) { unlink(sqlfile) }
m <- dbDriver("SQLite")
conn <- dbConnect(m, dbname=sqlfile)
dbWriteTable(conn, "students", students[!is.na(students$CreatedDate),])
dbDisconnect(conn)

##### RPostgreSQL test using Postgress.app #####################################
require(RPostgreSQL)
drv <- dbDriver('PostgreSQL')
con <- dbConnect(drv, dbname='jbryer', user='', password='', host='localhost', port=5432)
class(con)
