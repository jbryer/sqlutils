#' Search paths for SQL repositories.
#' 
#' @param path new path to add. This can a character vector of length greater than 1.
#' @param replace if FALSE, the path(s) will be added to already existing list.
#' @export
sqlPaths <- function(path, replace=FALSE) {
	pkgEnv <- pos.to.env(match('package:sqlutils', search()))
	#Calling unlockBinding will cause a Note when checking the package, but
	#there seems to be no other way to change this variable
	try(unlockBinding("sqlrepos", pkgEnv))
	paths <- unlist(mget("sqlrepos", envir=pkgEnv, 
			ifnotfound=list(paste(system.file(package='sqlutils'), '/data', sep=''))))
	if(!missing(path)) {
		path <- normalizePath(path.expand(path), mustWork=FALSE)
		if(replace) {
			paths <- unique(c(path))
		} else {
			paths <- unique(c(path, paths))
		}
		assign("sqlrepos", value=paths, envir=pkgEnv)
	}
	return(unname(paths))
}

#' Returns the full path to the query or NULL if not found.
#' 
#' @param query the query to find.
#' @return path to the query file.
sqlFile <- function(query) {
	paths <- sqlPaths()
	for(p in paths) {
		f <- paste(p, '/', query, '.sql', sep='')
		if(file.exists(f)) {
			return(f)
		}
	}
	warning(paste(query, ' not found.', sep=''))
	invisible(NULL)
}
