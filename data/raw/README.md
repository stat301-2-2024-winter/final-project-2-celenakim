## Allies Dataset


The data that I chose for my project was derived from gathering data on the psychological analysis of comments under the Jubilee video titled [Are We Allies? Black Americans vs Asian Americans | Middle Ground](https://www.youtube.com/watch?v=pXo2ub_nZFc) found on [YouTube](https://www.youtube.com). This video features a poignant discussion between East Asian Americans and Black Americans, highlighting the conflict and tension present between these groups. 

Using Python code, I first extracted each comment and its details such as like count and number of replies and put them into a spreadsheet. Then, utilizing the software LIWC[^1], a text analysis program that can categorize text by the overall emotion they convey, each comment was analyzed and given a score of how much they communicate each of 49 various emotions/categories such as anger, clout, affiliation, power, assent, insight, sad, etc.

[^1]: an explanation of how this software works can be found [here](https://www.liwc.app/help/howitworks)

The data set that I created from the steps highlighted in the previous section is called `allies_data`. The raw data set contains 15,398 observations and 66 variables. Of these variables, there are 7 categorical and 59 numerical.

