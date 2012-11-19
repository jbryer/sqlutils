\name{cacheQuery}
\alias{cacheQuery}
\title{This will first look in the given directory for a CSV version of the file, if
it exists, that will be read and returned. Otherwise it will execute the query
and then saves a CSV file.}
\usage{
  cacheQuery(query = NULL, dir = getwd(),
    filename = getCacheFilename(query = query, dir = dir, ...),
    format = "rda", ...)
}
\arguments{
  \item{dir}{the directory to save and load cached data
  files. Defaults to the current working directory (i.e.
  \code{\link{getwd}}.}

  \item{filename}{the filename of the cached data file.}

  \item{query}{the query to execute.}

  \item{...}{other parameters passed to the
  \code{execQuery} function including query parameters.}
}
\value{
  a data frame.
}
\description{
  This will first look in the given directory for a CSV
  version of the file, if it exists, that will be read and
  returned. Otherwise it will execute the query and then
  saves a CSV file.
}

