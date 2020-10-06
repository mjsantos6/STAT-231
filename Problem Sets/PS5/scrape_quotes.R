library(rvest)
library(methods)
url <- "https://www.brainyquote.com/topics/resilience-quotes"
fquotes <- url %>% read_html() %>% html_nodes(".oncl_q") %>% html_text()
fperson <- url %>% read_html() %>% html_nodes(".oncl_a") %>% html_text()
quotes_dat <- data.frame(fperson = fperson, fquote = fquotes, stringsAsFactors = FALSE) %>% mutate(together = paste('"', as.character(fquote), '" --', as.character(fperson), sep=""))
write_csv(quotes_dat, "~/Desktop/STAT-231/PS5/quotes.csv", append = FALSE)
