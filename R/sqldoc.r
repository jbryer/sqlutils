#' Parses the query and returns a list with all the elements of the comment.
#' 
#' @param query the query name.
#' @return a list with documentation including \code{introduction}, \code{return},
#'         and \code{params} (as a data frame).
#' @export
sqldoc <- function(query) {
	f <- sqlutils:::sqlFile(query)
	if(is.null(f)) { stop(paste("Cannot find query file for ", query, sep='')) }
	
	sql = scan(f, what="character", 
			   sep=';', multi.line=FALSE, comment.char=c(""), quiet=TRUE, quote=NULL)
	l <- c()
	for(i in seq_along(sql)) {
		if(substr(sql[1], 1,2) == "#'") {
			l = c(l, i)
		}
	}
	if(length(l) == 0) return(list())
	lines <- sql[l]
	
	#Borrowed heavily from roxygen2
	#https://github.com/yihui/roxygen2/blob/master/R/parse-preref.R
	LINE.DELIMITER <- "\\s*#+' ?"
	delimited.lines <- lines[str_detect(lines, LINE.DELIMITER)]
	trimmed.lines <- str_trim(str_replace(delimited.lines, LINE.DELIMITER, ""), "right")
	if (length(trimmed.lines) == 0) return(list())
	joined.lines <- str_c(trimmed.lines, collapse = '\n')
	elements <- strsplit(joined.lines, '(?<!@)@(?!@)', perl = TRUE)[[1]]
	elements <- str_replace_all(elements, fixed("@@"), "@")
	parsed.introduction <- roxygen2:::parse.introduction(elements[[1]])
	parsed.elements <- unlist(lapply(elements[-1], parse.element), recursive = FALSE)
	
	sqldoc <- c(parsed.introduction, parsed.elements)
	if(length(getParameters(query)) > 0 & !is.na(getParameters(query)[1])) {
		params <- data.frame(param=getParameters(query), desc=NA, default=NA, default.val=NA, 
							 stringsAsFactors=FALSE)
		for(l in sqldoc[names(sqldoc) == 'param']) {
			params[params$param == l$name,]$desc <- l$description
		}
		for(l in sqldoc[names(sqldoc) == 'default']) {
			params[params$param == l$name,]$default <- l$description
			params[params$param == l$name,]$default.val <- eval(parse(text=l$description))
		}
		sqldoc$params <- params
	}
	returns <- data.frame(variable=character(), desc=character(), stringsAsFactors=FALSE)
	for(l in sqldoc[names(sqldoc) == 'return']) {
		returns <- rbind(returns, data.frame(
			variable=l$name, desc=l$description, stringsAsFactors=FALSE))
	}
	
	sqldoc <- sqldoc[!(names(sqldoc) %in% c('param', 'default', 'return'))]
	sqldoc$returns <- returns
	
	class(sqldoc) <- c('sqldoc')
	return(sqldoc)
}

#' Prints the SQL documentation.
#' @param x sqldoc object.
#' @param ... currently unused.
#' @export
print.sqldoc <- function(x, ...) {
	cat(x$introduction)
	cat('\n')
	if(!is.null(x$params)) {
		cat('Parameters:\n')
		print(x$params, row.names=FALSE)
	}
	if(!is.null(x$returns)) {
		cat('Returns (note that this list may not be complete):\n')
		print(x$returns, row.names=FALSE)
	}
}

#' Parse a raw string containing key and expressions.
#'
#' Copied from roxygen2: https://github.com/yihui/roxygen2/blob/master/R/parse-preref.R
#'
#' @param element the string containing key and expressions
#' @param srcref source reference.
#' @return A list containing the parsed constituents
#' @author yihui
parse.element <- function(element, srcref) {
	#TODO: This should only be done once when the package loads
	preref.parsers <- roxygen2:::preref.parsers
	preref.parsers[['default']] <- preref.parsers[['param']]
	preref.parsers[['return']] <- preref.parsers[['param']]
	
	pieces <- str_split_fixed(element, "[[:space:]]+", 2)
	
	tag <- pieces[, 1]
	rest <- pieces[, 2]
	
	tag_parser <- preref.parsers[[tag]] %||% parse.unknown 
	tag_parser(tag, rest, NULL)
}

#' Parse introduction: the premier part of a roxygen block
#' containing description and option details separated by
#' a blank roxygen line.
#'
#' Copied from roxygen2: https://github.com/yihui/roxygen2/blob/master/R/parse-preref.R
#'
#' @param expression the description to be parsed
#' @return A list containing the parsed description
#' @author yihui
parse.introduction <- function(expression) {
	if (is.null.string(expression)) return(NULL)
	list(introduction = str_trim(expression))
}

#' Does the string contain no matter, but very well [:space:]?
#' @param string the string to check
#' @return TRUE if the string contains words, otherwise FALSE
is.null.string <- function(string) {
	str_length(str_trim(string)) == 0
}

#' Utility function
#' @rdname percentor
#' @name percentor
"%||%" <- function(a, b) {
	if (!is.null(a)) a else b
}
