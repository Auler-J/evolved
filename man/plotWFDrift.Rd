% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_helper_functions.R
\name{plotWFDrift}
\alias{plotWFDrift}
\title{Plot WFDriftSim output}
\usage{
plotWFDrift(p.through.time, plot.type = plot, knitr = FALSE)
}
\arguments{
\item{p.through.time}{Matrix with n.gen columns and n.sim lines}

\item{plot.type}{String. Options are "static" or "animate"}

\item{knitr}{Logical indicating if plot is intended to show up in RMarkdown files made by the \code{Knitr} R package.}
}
\value{
A static or animated plot of populations under genetic drift through time
}
\description{
Plot WFDriftSim output
}
\examples{
store_p = WFDriftSim(Ne = 5, n.gen = 10, p0=.2, n.sim=5, plot = "none", print.data = TRUE)
plotWFDrift(store_p, "static")
}
