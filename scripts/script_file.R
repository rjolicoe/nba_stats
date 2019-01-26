# Team statistics page
test <- NBAStandingsByDate(Sys.Date())

test <- test$East
View(test)

# Player Statistics

player <- NBAPerGameStatistics(season = 2017)  %>%
            dplyr::filter(mp > 20, pos %in% c("SF")) %>%
            dplyr::select(player, link) %>%
            dplyr::distinct()