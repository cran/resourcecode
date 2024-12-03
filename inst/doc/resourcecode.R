## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "100%",
  fig.align = "center",
  fig.retina = 3
)

## ----echo = FALSE-------------------------------------------------------------
has_data <- requireNamespace("resourcecodedata", quietly = TRUE)
if (!has_data) {
  knitr::opts_chunk$set(eval = FALSE)
  msg <- paste(
    "Note: Examples in this vignette require that the",
    "`resourcecodedata` package be installed. The system",
    "currently running this vignette does not have that package",
    "installed, so code examples will not be evaluated."
  )
  msg <- paste(strwrap(msg), collapse = "\n")
  message(msg)
}

## ----install-data, eval=F-----------------------------------------------------
# install.packages("resourcecodedata",
#   repos = "https://resourcecode-project.github.io/drat/",
#   type = "source"
# )

## ----setup--------------------------------------------------------------------
library(resourcecodedata)
library(resourcecode)
library(ggplot2)

## -----------------------------------------------------------------------------
str(rscd_field)
head(rscd_field)

## -----------------------------------------------------------------------------
str(rscd_variables)
head(rscd_variables)

## ----fig.retina=3-------------------------------------------------------------
lim_lon <- c(-5.25, -4.25)
lim_lat <- c(47.75, 48.75)
field_bzh <- ggplot(rscd_field, aes(x = longitude, y = latitude)) +
  geom_point(size = .1, col = "lightblue") +
  geom_path(data = rscd_coastline, linewidth = .2) +
  geom_path(data = rscd_islands, aes(group = .data$ID), linewidth = .2) +
  coord_sf(xlim = lim_lon, ylim = lim_lat, expand = FALSE, crs = sf::st_crs(4326)) +
  theme_void()
field_bzh

## -----------------------------------------------------------------------------
str(rscd_spectral)
head(rscd_spectral)

## ----fig.retina=3-------------------------------------------------------------
field_bzh + geom_point(data = rscd_spectral, col = "orange", size = .1)

## ----fig.height=4,fig.width=8,warning=FALSE,message=FALSE---------------------
point_of_interest <- c(longitude = -4.6861533, latitude = 48.3026514)
node <- closest_point_field(point_of_interest)
node
ts <- get_parameters(node = node$point, parameters = c("hs", "tp", "dp", "cge"))
ggplot(tidyr::pivot_longer(ts, -1), aes(x = time, y = value, col = name)) +
  geom_line() +
  coord_cartesian(expand = FALSE) +
  facet_wrap(~name, ncol = 2, scales = "free_y") +
  scale_x_datetime(name = NULL, date_breaks = "month") +
  scale_y_continuous(name = NULL) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 60, hjust = 1)
  )

## -----------------------------------------------------------------------------
node_spectral_grid <- closest_point_spec(point_of_interest)

## -----------------------------------------------------------------------------
spec_1d <- get_1d_spectrum(node_spectral_grid$point, start = "1994-01-01", end = "1994-02-28")
str(spec_1d)

## -----------------------------------------------------------------------------
spec_2d <- get_2d_spectrum(node_spectral_grid$point, start = "1994-01-01", end = "1994-02-28")
str(spec_2d)

## ----warning=FALSE, fig.height=8,fig.width=8----------------------------------
plot_2d_specta(spec_2d, "1994-01-15 18:00")

