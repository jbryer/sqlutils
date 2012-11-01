\name{sqlexec.RODBC}
\alias{sqlexec.RODBC}
\title{Executes queries for RODBC package.}
\usage{
  \method{sqlexec}{RODBC} (connection, sql, ...)
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
  Executes queries for RODBC package.
}

