# Team statistics page
test <- NBAStandingsByDate(Sys.Date())


# Player Statistics a function to output the details for players

player <- function(season, mins, position) {
  NBAPerGameStatistics(season = season)  %>%
    # dplyr::filter(mp > mins, pos %in% c(position)) %>%
    # dplyr::select(player, link, g) %>%
    dplyr::distinct()
  
}

