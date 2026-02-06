## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "100%",
  fig.align = "center",
  fig.retina = 3
)

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
if (!is.null(ts)) {
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
}

## -----------------------------------------------------------------------------
node_spectral_grid <- closest_point_spec(point_of_interest)

## ----eval = FALSE-------------------------------------------------------------
# spec_1d <- get_1d_spectrum(node_spectral_grid$point, start = "1994-01-01", end = "1994-02-28")
# str(spec_1d)

## ----eval = FALSE-------------------------------------------------------------
# spec_1d <- resourcecodedata::rscd_1d_spectra
# str(spec_1d)

## ----eval = FALSE-------------------------------------------------------------
# spec_2d <- get_2d_spectrum(node_spectral_grid$point, start = "1994-01-01", end = "1994-02-28")
# str(resourcecodedata::rscd_2d_spectra)

## ----warning=FALSE, fig.height=8,fig.width=8----------------------------------
plot_2d_specta(resourcecodedata::rscd_2d_spectra, "1994-01-15 18:00")

