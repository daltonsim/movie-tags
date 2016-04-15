
#QUESTION 1
library(ggplot2)
genre_count_data <- read.csv('genre_counts.csv')

ggplot(data = genre_count_data, aes(x = reorder(genre_count_data$genre, -genre_count_data$count),  y = genre_count_data$count, color = genre, fill = genre)) +
  geom_bar(stat = "identity") + theme(legend.title=element_blank()) +
  theme(axis.text.x = element_text(angle = 75, hjust = 1)) + xlab("Genre") + ylab("Count") + ggtitle("Genre Tag Frequency")



#QUESTION 2
genre_data <- read.csv('genres.csv', stringsAsFactors = FALSE)

ggplot(data = genre_data, aes(genre_data$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Genre Tags per Movie") + xlab("Movie Count") + ggtitle("Number of Genre Tags per Movie")


genre_counts <- table(genre_data$genre_count)
names(genre_counts) = c("One","Two","Three","Four","Five","Six","Seven","Eight","Nine")
lbls <- paste(names(genre_counts), sep="")
pie(genre_counts, labels = lbls, 
    main="Number of Genres to Describe a Movie")



# QUESTION 3
library(DBI)
library(RSQLite)

dbdriver = dbDriver("SQLite")
connect = dbConnect(dbdriver, dbname = "Genres.db")


Mystery = dbGetQuery(connect, "Select * from Genres where genres like '%Mystery%'")
Romance = dbGetQuery(connect, "Select * from Genres where genres like '%Romance%'")
SciFi = dbGetQuery(connect, "Select * from Genres where genres like '%Sci-Fi%'")
Horror = dbGetQuery(connect, "Select * from Genres where genres like '%Horror%'")
FilmNoir = dbGetQuery(connect, "Select * from Genres where genres like '%Film-Noir%'")
Crime = dbGetQuery(connect, "Select * from Genres where genres like '%Crime%'")
Drama = dbGetQuery(connect, "Select * from Genres where genres like '%Drama%'")
Fantasy = dbGetQuery(connect, "Select * from Genres where genres like '%Fantasy%'")
Musical = dbGetQuery(connect, "Select * from Genres where genres like '%Musical%'")
Animation = dbGetQuery(connect, "Select * from Genres where genres like '%Animation%'")
War = dbGetQuery(connect, "Select * from Genres where genres like '%War%'")
Adventure = dbGetQuery(connect, "Select * from Genres where genres like '%Adventure%'")
Action = dbGetQuery(connect, "Select * from Genres where genres like '%Action%'")
Comedy = dbGetQuery(connect, "Select * from Genres where genres like '%Comedy%'")
Documentary = dbGetQuery(connect, "Select * from Genres where genres like '%Documentary%'")
Children = dbGetQuery(connect, "Select * from Genres where genres like '%Children%'")
Thriller = dbGetQuery(connect, "Select * from Genres where genres like '%Thriller%'")
Western = dbGetQuery(connect, "Select * from Genres where genres like '%Western%'")


ggplot(data = Mystery, aes(Mystery$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Mystery") 
ggplot(data = Romance, aes(Romance$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Romance") 
ggplot(data = SciFi, aes(SciFi$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("SciFi") 
ggplot(data = Horror, aes(Horror$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Horror") 
ggplot(data = FilmNoir, aes(FilmNoir$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Film-Noir") 
ggplot(data = Crime, aes(Crime$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Crime") 
ggplot(data = Drama, aes(Drama$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Drama") 
ggplot(data = Fantasy, aes(Fantasy$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Fantasy") 
ggplot(data = Musical, aes(Musical$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Musical") 
ggplot(data = Animation, aes(Animation$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Animation") 
ggplot(data = War, aes(War$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("War") 
ggplot(data = Adventure, aes(Adventure$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Adventure") 
ggplot(data = Action, aes(Action$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Action") 
ggplot(data = Comedy, aes(Comedy$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Comedy") 
ggplot(data = Documentary, aes(Documentary$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Documentary") 
ggplot(data = Children, aes(Children$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Children") 
ggplot(data = Thriller, aes(Thriller$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Thriller") 
ggplot(data = Western, aes(Western$genre_count)) + geom_histogram(breaks=seq(0, 7, by=1)) + 
  xlab("Size of Genre Group") + ggtitle("Western") 

# QUESTION 4
library(plyr)

 rating_data <- read.csv('ratings.csv', stringsAsFactors = FALSE)
 avg_ratings.plyr <- ddply( rating_data, .(movieId), function(x) mean(x$rating) )
 colnames(avg_ratings.plyr) <- c("movieid", "avg_str_rating")

 cmbd_rating_data <- merge(genre_data,avg_ratings.plyr,by="movieid")

 movie_data_final = cmbd_rating_data[order(-cmbd_rating_data$avg_str_rating),] 
 write.csv(cmbd_rating_data , file = "ratings_avg.csv")
 write.csv(movie_data_final , file = "movie_data_final.csv")

dbdriver = dbDriver("SQLite")
connect = dbConnect(dbdriver, dbname = "movies.db")

Mystery_top = dbGetQuery(connect, "Select * from Movies where genres like '%Mystery%' limit 10")
Romance_top = dbGetQuery(connect, "Select * from Movies where genres like '%Romance%' limit 10")
SciFi_top = dbGetQuery(connect, "Select * from Movies where genres like '%Sci-Fi%' limit 10")
Horror_top = dbGetQuery(connect, "Select * from Movies where genres like '%Horror%' limit 10")
FilmNoir_top = dbGetQuery(connect, "Select * from Movies where genres like '%Film-Noir%' limit 10")
Crime_top = dbGetQuery(connect, "Select * from Movies where genres like '%Crime%' limit 10")
Drama_top = dbGetQuery(connect, "Select * from Movies where genres like '%Drama%' limit 10")
Fantasy_top = dbGetQuery(connect, "Select * from Movies where genres like '%Fantasy%' limit 10")
Musical_top = dbGetQuery(connect, "Select * from Movies where genres like '%Musical%' limit 10")
Animation_top = dbGetQuery(connect, "Select * from Movies where genres like '%Animation%' limit 10")
War_top = dbGetQuery(connect, "Select * from Movies where genres like '%War%' limit 10")
Adventure_top = dbGetQuery(connect, "Select * from Movies where genres like '%Adventure%' limit 10")
Action_top = dbGetQuery(connect, "Select * from Movies where genres like '%Action%' limit 10")
Comedy_top = dbGetQuery(connect, "Select * from Movies where genres like '%Comedy%' limit 10")
Documentary_top = dbGetQuery(connect, "Select * from Movies where genres like '%Documentary%' limit 10")
Comedy_top = dbGetQuery(connect, "Select * from Movies where genres like '%Comedy%' limit 10")
Children_top = dbGetQuery(connect, "Select * from Movies where genres like '%Children%' limit 10")
Thriller_top = dbGetQuery(connect, "Select * from Movies where genres like '%Thriller%' limit 10")
Western_top = dbGetQuery(connect, "Select * from Movies where genres like '%Western%' limit 10")


movies <- read.csv('movies.csv', stringsAsFactors = FALSE)
colnames(movies) <- c("movieid", "title","genres_raw")
mystery_data <- merge(Mystery_top,movies,by="movieid")
romance_data <- merge(Romance_top,movies,by="movieid")
scifi_data <- merge(SciFi_top,movies,by="movieid")
horror_data <- merge(Horror_top,movies,by="movieid")
filmnoir_data <- merge(FilmNoir_top,movies,by="movieid")
crime_data <- merge(Crime_top,movies,by="movieid")
drama_data <- merge(Drama_top,movies,by="movieid")
fantasy_data <- merge(Fantasy_top,movies,by="movieid")
musical_data <- merge(Musical_top,movies,by="movieid")
animation_data <- merge(Animation_top,movies,by="movieid")
war_data <- merge(War_top,movies,by="movieid")
adventure_data <- merge(Adventure_top,movies,by="movieid")
action_data <- merge(Action_top,movies,by="movieid")
comedy_data <- merge(Comedy_top,movies,by="movieid")
children_data <- merge(Children_top,movies,by="movieid")
thriller_data <- merge(Thriller_top,movies,by="movieid")
western_data <- merge(Western_top,movies,by="movieid")