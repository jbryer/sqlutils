\name{sqlexec.SQLiteConnection}
\alias{sqlexec.SQLiteConnection}
\title{Executes queries for RSQLite package.}
\usage{
  \method{sqlexec}{SQLiteConnection} (connection, sql, ...)
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
  Executes queries for RSQLite package.
}

