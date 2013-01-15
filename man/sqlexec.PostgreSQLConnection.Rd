\name{sqlexec.PostgreSQLConnection}
\alias{sqlexec.PostgreSQLConnection}
\title{Executes queries for RPostgreSQL}
\usage{
  \method{sqlexec}{PostgreSQLConnection} (connection, sql,
    ...)
}
\arguments{
  \item{connection}{the database connection.}

  \item{sql}{the query to execute.}

  \item{...}{other parameters passed to the appropriate
  \code{sqlexec} function.}
}
\value{
  a data frame.
}
\description{
  Executes queries for RPostgreSQL
}

