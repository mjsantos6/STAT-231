library(rvest)
library(methods)
url <- "https://en.wikipedia.org/wiki/List_of_justices_of_the_Supreme_Court_of_the_United_States"
tables = url %>% read_html() %>% html_nodes("table")
length(tables)
Justices <- html_table(tables[[2]], fill = TRUE)
write_csv(Justices, "~/Desktop/STAT-231/PS5/justices.csv", append = FALSE)
