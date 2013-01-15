#' Utilities for managing a library of SLQ files. 
#' 
#' @name sqlutils-package
#' @aliases sqlutils
#' @docType package
#' @title Utilities for working with SQL files.
#' @author Jason Bryer \email{jason@@bryer.org}
#' @keywords package database sql
NULL

#' The locations of SQL files
sqlrepos <- NA

.onAttach <- function(libname, pkgname) {
	pkgEnv = pos.to.env(match('package:sqlutils', search()))	
	assign("sqlrepos", value=c(paste(system.file(package='sqlutils'), '/sql', sep='')), 
		   envir=pkgEnv)
}
