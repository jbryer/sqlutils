#' This will first look in the given directory for a CSV version of the file, if
#' it exists, that will be read and returned. Otherwise it will execute the query
#' and then saves a CSV file.
#' 
#' @param dir the directory to save and load cached data files. Defaults to the
#'        current working directory (i.e. \code{\link{getwd}}.
#' @param filename the filename of the cached data file.
#' @param query the query to execute.
#' @param maxLevels the maximum number of levels a factor can have before being
#'        converted to a character.
#' @param ... other parameters passed to the \code{execQuery} function including
#'        query parameters.
#' @param format either csv for comma separated value files or rda for R data files.
#' @return a data frame.
#' @export
cacheQuery <- function(query=NULL, dir=getwd(), 
					   filename=getCacheFilename(query=query, dir=dir, ext=format, ...), 
					   format='csv', 
					   maxLevels=20, 
					   ...) {
	if(file.exists(filename)) {
		message(paste("Reading from cached query file: ", filename, sep=''))
		if(tolower(format) == 'rda') {
			load(filename)
		} else if(tolower(format) == 'csv') {
			df = read.csv(filename)			
		} else {
			stop('Unsupported format type.')
		}
		df = recodeColumns(df, maxLevels)
	} else {
		message(paste("Executing ", query, " and saving to ", filename, sep=''))
		df = execQuery(query=query, maxLevels=maxLevels, ...)
		if(tolower(format) == 'rda') {
			save(df, file=filename)
		} else if(tolower(format) == 'csv') {
			write.csv(df, filename, row.names=FALSE)
		} else {
			stop('Unsupported format type.')
		}
	}
	return(df)
}

#' Returns the complete filepath to the cache file.
#' 
#' @param query the query name.
#' @param dir the directory to save the cache file to.
#' @param ext file extension.
#' @param ... query parameters.
#' @return full filepath to the cached file.
#' @export
getCacheFilename <- function(query, dir=getwd(), ext='csv', ...) {
	parms = getParameters(query)
	parmvals = unlist(list(...))
	filename = paste(dir, '/', query, sep='')
	if(length(parms) > 0) {
		for(i in 1:length(parms)) {
			filename = paste(filename, parms[i], parmvals[parms[i]], sep='.')
		}
	}
	filename = paste(filename, ext, sep='.')
	return(filename)
}
