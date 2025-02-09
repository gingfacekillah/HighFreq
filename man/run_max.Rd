% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{run_max}
\alias{run_max}
\title{Calculate the running maximum values of streaming \emph{time series} data.}
\usage{
run_max(tseries, lambda)
}
\arguments{
\item{\code{tseries}}{A \emph{time series} or a \emph{matrix}.}

\item{\code{lambda}}{A \emph{numeric} decay factor to multiply past
estimates.}
}
\value{
A \emph{matrix} with the same dimensions as the input argument
  \code{tseries}.
}
\description{
Calculate the running maximum values of streaming \emph{time series} data.
}
\details{
The function \code{run_max()} calculates the running maximum of streaming
  \emph{time series} data by recursively weighing present and past values
  using the decay factor \eqn{\lambda}.

  It calculates the running maximum values \eqn{p^{max}_t} of the streaming
  data \eqn{p_t} as follows:
  \deqn{
    p^{max}_t = max(p_t, \lambda p^{max}_{t-1} + (1-\lambda) p_t)
  }
  The first term in the sum is the maximum value multiplied by the decay
  factor \eqn{\lambda}, so that the past maximum value is gradually
  "forgotten". The second term pulls the maximum value to the current value
  \eqn{p_t}.
  
  The value of the decay factor \eqn{\lambda} should be in the range between
  \code{0} and \code{1}.  
  If \eqn{\lambda} is close to \code{1} then the past maximum values persist
  for longer.  This is equivalent to a long look-back interval.
  If \eqn{\lambda} is much less than \code{1} then the past maximum values
  decay quickly, and the running maximum depends on the more recent
  streaming values.  This is equivalent to a short look-back interval.

  The above formula can also be expressed as:
  \deqn{
    p^{max}_t = \lambda max(p_t, p^{max}_{t-1}) + (1-\lambda) p_t
  }
  The first term is the maximum value multiplied by the decay factor
  \eqn{\lambda}, so that the past maximum value is gradually "forgotten".
  The second term pulls the maximum value to the current value \eqn{p_t}.
  
  The above recursive formula is convenient for processing live streaming
  data because it doesn't require maintaining a buffer of past data.

  The function \code{run_max()} returns a \emph{matrix} with the same
  dimensions as the input argument \code{tseries}.
}
\examples{
\dontrun{
# Calculate historical prices
prices <- zoo::coredata(quantmod::Cl(rutils::etfenv$VTI))
# Calculate the running maximums
lambda <- 0.9
maxv <- HighFreq::run_max(prices, lambda=lambda)
# Plot dygraph of VTI prices and running maximums
datav <- cbind(quantmod::Cl(rutils::etfenv$VTI), maxv)
colnames(datav) <- c("prices", "max")
colnamev <- colnames(datav)
dygraphs::dygraph(datav, main="VTI Prices and Running Maximums") \%>\%
  dySeries(name=colnamev[1], label=colnamev[1], strokeWidth=2, col="blue") \%>\%
  dySeries(name=colnamev[2], label=colnamev[2], strokeWidth=2, col="red")
}

}
