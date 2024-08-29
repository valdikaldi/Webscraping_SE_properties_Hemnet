# Webscraping_SE_properties_Hemnet

![Hemnet Front page](front_page.PNG)

## Description : 
In this project, I web scrape the website "www.hemnet.se", Swedens biggest property platform. I will gather historical transaction data on properties and their characteristics. 

In order to over come few challenges I utilize the well known and powerful Selenium library to construct by bot.  

Objective: Collect as much data on Swedish properties as possible - in a controlled and respectful manner without overloading their servers (Even though that is unlikely to happen.) 

## Overview of the code : 

Unlike the previous web scraping projects, scraping this website comes with three challenges :

### First off
  * "hidden" API: There is no access to a "hidden" API, therefore there is no easy way out where we simply plug in to the API and make few GET requests.
    * Hemnet does host an API, however its use is only for brokers or broker agencies.  

### Second challenge
  * Captcha : When I tested couple of simple scripts using BeautifulSoup and ran a few iterations over multiple pages, something seemed to trigger a CAPTCHA. It appears that they monitor users quite effectively. 

### Third and final challenge:
  * For each page the site displays 20 properties
  * However, regardless of the search and filter criteria set in place, the site only allows access to 50 pages. Meaning that if we search e.g. for properties in Stockholm municipality wich leads to results of 205.885 properties, then users are only allowed access to 2500 properties. 

![search](search_Stockholm_result.PNG)

To overcome the first two challenges I use the Selenium package. Unlike BeautifulSoup (which is primarily used as a HTML parser) Selenium allows me to construct a BOT i.e. by using Selenium I can automate interactions with a web browser which makes my traffic seem like a human and therefore helps prevent getting blocked or trickering a CAPTCHA. 

To over come the third challenge I let the BOT use the filtering criteria offered on the website i.e. property type, number of rooms, property size and transaction price. 

Following is a description on how the BOT runs: 
  * **Step 1** - loop over municipality names and search for properties in each
    * I keep a list of all 290 municipalities of Sweden in a csv file - see folder *Sweden_municipalities_data*
    * **Step 2** - Get the total search results in municipality
      * **Step 3** - If  


![Search result](SearchResult_number_of_pages.PNG)


## Result : 

## Example Data

You can view an example of the tabular data from the final result in the CSV file located in the example_data folder
