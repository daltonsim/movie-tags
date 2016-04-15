#Written by Dalton Simancek for Final Project
# SI 618 Winter 2015

import csv, sys, json, sqlite3

"""
METHOD: movieDataCSV_to_ListGenreDicts
INPUT: movies.csv (SOURCE: MovieLens)
DESCRIPTION: Creates a list of dictionaries containting genre tags
"""
def movieDataCSV_to_ListGenreDicts(movies):
    list_genre_dicts = []
    try:
        with open(movies, 'rb') as movie_data:
            genres = csv.reader(movie_data, delimiter=',')
            next(genres)
            for line in genres:
                if line[2] and "genre" not in line[2]:
                    line[2] = line[2].replace("|"," ")
                    line[2] = line[2].replace("(","")
                    line[2] = line[2].replace(")","")
                    line[2] = line[2].split()
                    new_dict = {
                    "movieid": line[0],
                    "genres": line[2]
                    }
                    count = 0
                    for genre in new_dict["genres"]:
                        count += 1
                        new_dict["genre_count"] = count
                        genre_list.append(new_dict)
            movie_data.close()
    except IOError:
        print "error with opening the file"

    return list_genre_dicts



"""
METHOD:countGenres
DESCRIPTION: Counts all genre tags among the list_genre_dicts
INPUT: List move genre dictionaries(list_genre_dicts)
"""
def countGenres(list_genre_dicts):
    genre_dict = {
    "Action":0,
    "Adventure":0,
    "Animation":0,
    "Children":0,
    "Comedy":0,
    "Crime":0,
    "Documentary":0,
    "Drama":0,
    "Fantasy":0,
    "Film-Noir":0,
    "Horror":0,
    "Musical":0,
    "Musical":0,
    "Mystery":0,
    "Romance":0,
    "Sci-Fi":0,
    "Thriller":0,
    "War":0,
    "Western":0,
    }
    for movie in list_genre_dicts:
        for genre in movie["genres"]:
            if genre in genre_dict:
                genre_dict[genre] += 1
    return genre_dict


"""
METHOD: create_genreList_textFile
DESCRIPTION: Converts python genre dictionary into csv file
INPUT: List of genre dictionaries(list_genre_dicts), name of output file(outputfile)
"""
def create_genreList_textFile(list_genre_dicts, outputfile):
    keys = list_genre_dicts[0].keys()
    with open(outputfile, 'wb') as outcsv:
        dict_writer = csv.DictWriter(outcsv, keys)
        dict_writer.writeheader()
        dict_writer.writerows(list_genre_dicts)


"""
METHOD: create_genreCount_textFile
DESCRIPTION: Converts python genre count dictionary into csv file
INPUT: List of genre counts(genre_list), name of output file(outputfile)
"""
def create_genreCount_textFile(genre_list, outputfile):

    with open(outputfile, 'wb') as outcsv:
        writer = csv.writer(outcsv)
        writer.writerow(["genre","count"])
        for key, value in genre_list.items():
            writer.writerow([key, value])

"""
METHOD: csv_to_db_genres
DESCRIPTION: csv genre file to database file
INPUT: genres.csv, name of output file(outputfile)
"""
def csv_to_db_genres(inputfile, outputfile):
    con = sqlite3.connect(outputfile)
    cur = con.cursor()

    cur.execute("DROP TABLE IF EXISTS Genres")
    cur.execute("CREATE TABLE Genres (genres TEXT, movieid INT, genre_count INT);")

    with open(inputfile,'rb') as fin: # `with` statement available in 2.5+
        # csv.DictReader uses first line in file for column headings by default
        dr = csv.DictReader(fin) # comma is default delimiter
        to_db = [(i['genres'], i['movieid'], i['genre_count']) for i in dr]

        cur.executemany("INSERT INTO Genres (genres, movieid, genre_count) VALUES (?, ?, ?);", to_db)
        con.commit()

"""
METHOD: csv_to_db_movies
DESCRIPTION: csv movie file to database file
INPUT: movies.csv, name of output file(outputfile)
"""
def csv_to_db_movies(inputfile, outputfile):
    con = sqlite3.connect(outputfile)
    cur = con.cursor()

    cur.execute("DROP TABLE IF EXISTS Movies")
    cur.execute("CREATE TABLE Movies (movieid INT, genres TEXT, genre_count INT, avg_str_rating REAL);")

    with open(inputfile,'rb') as fin: # `with` statement available in 2.5+
        # csv.DictReader uses first line in file for column headings by default
        dr = csv.DictReader(fin) # comma is default delimiter
        to_db = [(i['movieid'], i['genres'], i['genre_count'], i['avg_str_rating']) for i in dr]

        cur.executemany("INSERT INTO Movies (movieid, genres, genre_count, avg_str_rating) VALUES (?, ?, ?, ?);", to_db)
        con.commit()


def main():
    if len(sys.argv[1:]) != 5:
        print 'Usage:\n commandline_args_example1.py movies.csv outputfileGenreCount outputfileGenreList inputDBfile outputfile'
        sys.exit(1)

    list_genre_dicts = movieDataCSV_to_ListGenreDicts(sys.argv[1])
    #genre_counts = countGenres(list_genre_dicts)
    #create_genreCount_textFile(genre_counts, sys.argv[2])
    #create_genreList_textFile(list_genre_dicts, sys.argv[3])
    #csv_to_db_genres(sys.argv[4],sys.argv[5])
    #csv_to_db_movies(sys.argv[4],sys.argv[5])

if __name__ == '__main__':
    main()
