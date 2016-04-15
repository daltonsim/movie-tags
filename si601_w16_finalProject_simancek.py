# -*- coding: utf-8 -*-
#Written by Dalton Simancek for Final Project
# SI 601 Winter 2015

from bs4 import BeautifulSoup
import json, urllib2, time, re, csv

#################################################
#######  STEP 1: Retrieve IMDB HTML Page  #######
#######    Input: None                    #######
#######    Output: HTML File              #######
#################################################
response = urllib2.urlopen('http://www.imdb.com/chart/top')
soup = BeautifulSoup(response.read().decode('utf-8'), "html.parser")
Html_file= open("step1_top250_simancek.html","w")
Html_file.write(str(soup))
Html_file.close()

###################################################################
#######  STEP 2: Parse HTML and retrieve imdb_id and title  #######
#######          for each movie in top 250                  #######
#######       Input: None                                   #######
#######       Ouput: List of Movie Data Dictionaries        #######
###################################################################
soup = BeautifulSoup(open("step1_top250_simancek.html"), "html.parser")

list_of_movieInfo_imdb = []
list_of_movieInfo_imdb_FINAL = []

for movie in soup.find_all("td", {"class": "titleColumn"}):
    list_of_movieInfo_imdb.append(movie)

#Parses html movie sections for title, imdb_id
for movie_html in list_of_movieInfo_imdb:
    title =  movie_html.find("a")
    imdb_id = re.search('tt[\d]+',str(title))
    list_of_movieInfo_imdb_FINAL.append([title.string.encode('utf-8'),imdb_id.group(0)])

imdb_info_dict_list = []

for movie in list_of_movieInfo_imdb_FINAL:
    new_dict = {
        "title":movie[0],
        "imdbId":movie[1],
        "movieId":""
    }
    imdb_info_dict_list.append(new_dict)

for movie in imdb_info_dict_list:
    movie["imdbId"]= movie["imdbId"][2:]

###################################################################
#######  STEP 3: Open links.csv to identify corresponding   #######
#######          movieid from MovieLens                     #######
#######       Input: links.csv                              #######
#######       Ouput: Updated Lists of Dicts w/ movieids     #######
###################################################################
with open('links.csv', 'rU') as f:
    IN = csv.reader(f, delimiter=",")
    #Skip the lables
    next(f)
    #Read through each row
    for line in IN:
        for movie_dict in imdb_info_dict_list:
            if line[1] == movie_dict["imdbId"]:
                movie_dict["movieId"] = line[0]
f.close

###################################################################
#######  STEP 4: Open tags.csv to retrieve corresponding    #######
#######          user content tags for top 250 movies       #######
#######       Input: tags.csv                               #######
#######       Ouput: Dictionary of tag frequencies          #######
###################################################################
tag_frequency_dict_list = []
with open('tags.csv', 'rU') as g:
        IN = csv.reader(g, delimiter=",")

        #Skip the lables
        next(g)

        #Read through each row
        for line in IN:
            for movie_dict in imdb_info_dict_list:
                if movie_dict["movieId"] == line[1]:
                    my_item = next((item for item in tag_frequency_dict_list if item['tag'].lower() == line[2].lower()), None)
                    if my_item not in tag_frequency_dict_list:
                        new_dict = {
                        "tag":line[2].lower(),
                        "counter": 1
                        }
                        tag_frequency_dict_list.append(new_dict)
                    else:
                        my_item["counter"] = my_item["counter"] + 1
        tag_list_sorted = sorted(tag_frequency_dict_list, key=lambda k: k["counter"], reverse=True)
g.close



###################################################################
#######  STEP 5: Create .csv file of tag frequency table    #######
#######       Input: None                                   #######
#######       Ouput: Imdb top 250 tag frequencies csv file  #######
###################################################################
fieldnames = ['tag','counter']
OUT = open('si601_w16_finalProject_imdb_tagFreq.csv', 'w')

csvwriter = csv.DictWriter(OUT, delimiter=',', fieldnames=fieldnames)
csvwriter.writeheader()
for row in tag_list_sorted:
    csvwriter.writerow(row)
OUT.close()
