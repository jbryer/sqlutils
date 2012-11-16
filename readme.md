# The sqlutils Package

The `sqlutils` package provides a set of utility functions to help manage a library of structured query language (SQL) files. The package can be installed from Github using the `devtools` package.

	require(devtools)
	install_github('sqlutils', 'jbryer')

The `sqlutils` package provides functions to document, cache, and execute SQL queries. The location of the SQL files is determined by the `sqlPaths()` function. This function behaves in a manner consistent with the `.libPaths()` function.
By default, a single path will be defined being the `data` directory where the `sqlutils` package is installed.

	> sqlPaths()
	[1] "/Users/jbryer/R/sqlutils/data"

Additional search paths can be added using `sqlPaths('/Path/To/SQL/Files')`. By convention, `sqlutils` will work with any plain text files with a `.sql` file extention in any of the directories returned from `sqlPaths()`. In the case of multiple files with the same name, first one wins.

In addition to working with a library (directory) of SQL files, `sqlutils` recognizes `roxygen2` style documentation. The `StudentsInRange` script (located in the `data` directory of the installed package), exemplifies how to create a SQL query with two parameters as well as how to define those parameters and provide default values. Default values are used when the user fails to supply values within the `execQuery` or `cacheQuery` functions (described in detail bellow).

    #' Students enrolled within the given date range.
    #' 
    #' @param startDate the start of the date range to return students.
    #' @default startDate '2011-07-01'
    #' @param endDate the end of the date range to return students.
    #' @default endDate as.character(Sys.Date())
    #' @return all students
    SELECT * 
    FROM students 
    WHERE CreatedDate >= ':startDate:' AND CreatedDate <= ':endDate:'

It should be noted that parameters are replaced just before executing the query and must be contained with a pair of colons (:) and be valid R object names (i.e. not start with a number, contain spaces, or special characters).

We can now retrieve the documentation from within R using the `sqldoc` command.

	> sqldoc('StudentsInRange')
	Students enrolled within the given date range.
    Returns all students
    Parameters:
        param                                            desc    default
    startDate the start of the date range to return students. 2011-07-01
      endDate   the end of the date range to return students. 2012-08-01

The required parameters can be retrieved using the `getParameters` function.

	> getParameters('StudentsInRange')
	[1] "startDate" "endDate"

In the case there are no parameters, an empty character vector is returned.

	> getParameters('StudentSummary')
    character(0)

A list of all available queries is returned using the `getQueries()` function.

	> getQueries()
	 [1] "StudentsInRange" "StudentSummary" 

There are two functions available to execute queries, `execQuery` and `cacheQuery`. The former will send the SQL query to the database upon every execution. The latter however, maintains a local cached version of the resulting data frame. Specifically, the function creates a unique filename based upon the query name and parameters (see `getCacheFilename` function; this can also be overwritten using the `filename` parameter). If that file exists in specified directory (the current working directory by default), then it reads the file from disk and returns that. If the file does not exist, then `execQuery` is called, the result data frame saved to disk, and then the data frame is returned. The following complete example loads the `students` data frame from the `retention` package, saves it to a SQLite database, and executes the two included queries.

	> require(RSQLite)
	> require(retention)
	> data(students)
	> m <- dbDriver("SQLite")
	> m <- dbDriver("SQLite")
	> conn <- dbConnect(m, dbname='students.db')
	> dbWriteTable(conn, "students", students[!is.na(students$CreatedDate),])
	> q1 <- execQuery('StudentSummary', connection=conn)
	> head(q1)
	   CreatedDate count(StudentId)
	 1       11883             8365
	 2       11914             8251
	 3       11945             8259
	 4       11975             8258
	 5       12006             8151
	 6       12036             8415

### Supported databases

The `sqlutils` package supports database access using the `RODBC`, `RSQLite`, and `RMySQL` packages using an S3 generic function call called `sqlexec` based upon the class of the `connection` parameter. For example, create a new database connection for connections of class `foo`, the following provides the skeleton of the function to implement:

	sqlexec.foo <- function(connection, sql, ...) {
		#Database implementation here.
		#The ... will be passed through from the execQuery call. 
	}
	
