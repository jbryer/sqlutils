#' Executes the specified query and returns a data frame. This function currently
#' supports RODBC, RSQLite, and RMySQL. For other databases, use getQuery() and
#' execute the SQL statement using the appropriate database connection.
#' 
#' @param query the query to execute.
#' @param connection the database connection.
#' @param ... other parameters passed to \code{\link{getSQL}} and \code{\link{sqlexec}}.
#' @seealso sqlexec, cacheQuery
#' @export
execQuery <- function(query=NULL, connection=NULL, ...) {
	sql = getSQL(query=query, ...)
	df <- sqlexec(connection, sql=sql, ...)
	return(df)
}

#' Generic function for executing a query.
#' 
#' @param connection the database connection.
#' @param sql the query to execute.
#' @param ... other parameters passed to the appropriate \code{sqlexec} function.
#' @return a data frame.
#' @export sqlexec
sqlexec <- function(connection, sql, ...) { UseMethod("sqlexec") }

#' Executes queries for RODBC package.
#' 
#' @param connection the database connection.
#' @param sql the query to execute.
#' @param ... other parameters passed to the appropriate \code{sqlexec} function.
#' @return a data frame.
#' @method sqlexec RODBC
#' @S3method sqlexec RODBC
#' @export
sqlexec.RODBC <- function(connection, sql, ...) {
	sqlQuery(connection, sql, ...)
}

#' Executes queries for RSQLite package.
#' 
#' @param connection the database connection.
#' @param sql the query to execute.
#' @param ... other parameters passed to the appropriate \code{sqlexec} function.
#' @return a data frame.
#' @method sqlexec SQLiteConnection
#' @S3method sqlexec SQLiteConnection
#' @export
sqlexec.SQLiteConnection <- function(connection, sql, ...) {
	dbGetQuery(connection, sql, ...)
}

#' Executes queries for RMySQL package.
#' 
#' @param connection the database connection.
#' @param sql the query to execute.
#' @param ... other parameters passed to the appropriate \code{sqlexec} function.
#' @return a data frame.
#' @method sqlexec RMySQL
#' @S3method sqlexec RMySQL
#' @export
sqlexec.RMySQL <- function(connection, sql, ...) {
	dbSendQuery(connection, sql, ...)
}
