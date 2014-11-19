#' Generic function for executing a query.
#' 
#' @param connection the database connection.
#' @param sql the query to execute.
#' @param ... other parameters passed to the appropriate \code{sqlexec} function.
#' @return a data frame.
#' @export sqlexec
sqlexec <- function(connection, sql, ...) { UseMethod("sqlexec") }

#' Executes queries for RODBC package.
#' @inheritParams sqlexec
sqlexec.RODBC <- function(connection, sql, ...) {
	require(RODBC)
	sqlQuery(connection, sql) #TODO: Why doesn't this work with ... passed through
}

#' Executes queries for RSQLite package.
#' @inheritParams sqlexec
sqlexec.SQLiteConnection <- function(connection, sql, ...) {
	require(RSQLite)
	dbGetQuery(connection, sql, ...)
}

#' Executes queries for RMySQL package.
#' @inheritParams sqlexec
sqlexec.RMySQL <- function(connection, sql, ...) {
	require(RMySQL)
	dbSendQuery(connection, sql, ...)
}

#' Executes queries for RPostgreSQL
#' @inheritParams sqlexec
sqlexec.PostgreSQLConnection <- function(connection, sql, ...) {
	require(RPostgreSQL)
	rs <- dbSendQuery(connection, sql)
	fetch(rs, n=-1)
}

#' Executes queries for RJDBC
#' @inheritParams sqlexec
sqlexec.JDBCConnection <- function(connection, sql, ...) {
	require(RJDBC)
	RJDBC::dbGetQuery(connection, sql)
}
