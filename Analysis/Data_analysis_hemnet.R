
library(dplyr) # %>%
library(data.table) # fread 
# install.packages("purrr")
library(purrr) #map_df
library(readr)
library(tidyr)
library(stringr) # replace comma with dot


#========================================================================================
# Swedish real estate glossary: 
# https://www.affidata.co.uk/sh/property-for-sale/swedish-real-estate-glossary-letter-t
#========================================================================================

################################## IMPORT ALL THE CSV FILES: TOTAL 2.710 FILES

# set directory
dir <- ' Set the directory to the folder -DATA -  containing all the csv files '
setwd(dir)
getwd()


# read IN ALL THE files and merge them into 1 set
    #  force all the columns to be as characters with the col_types argument

csvCollection <-
  list.files(pattern = "*.csv") %>%
  map_df(~read_csv(.,col_types = cols(.default = "c")) )


# save as csv file.

write.csv(csvCollection, 'C:/Users/ABC/Desktop//Uni Oldenburg//jobHUSE//Task_datacollection//Sweden//Hemnet_db.csv', fileEncoding = 'UTF-8' )




############################# SETTING UP THE KOMMUN NAME / MUNICIPALITIES & Urban area names (locality)


# Create new column "Kommun_name" which only has the column name - taken from column "houseAddress_2"
kommun <- csvCollection[,4]

# split it into 3 columns
kommun <- separate(kommun, col = houseAddress_2, sep = "," , into = c('Houseaddress_2', 'Houseaddress_3','Houseaddress_4'))

# number of distinct values
n_distinct(kommun$Houseaddress_2)
n_distinct(kommun$Houseaddress_3)
n_distinct(kommun$Houseaddress_4)


kommun$KOMMUN <- as.vector(str_split_fixed(x, pattern = "", n = nchar(x)))


kommun$KOMMUN2 <- 0

## Create the correct column with the kommun names
# for (cell in 1:nrow(kommun)) {
#   print(cell)
#   textcell2 = kommun$Houseaddress_2[cell]
#   # print(textcell2)
#   textcell3 = kommun$Houseaddress_3[cell]
#   # print(textcell3)
#   textcell4 = kommun$Houseaddress_4[cell]
#   # print(textcell4)
#
#   if("kommun" %in% as.vector(str_split_fixed(textcell2, pattern = " ", n = 10))){
#     kommun$KOMMUN2[cell] = textcell2
#     # print(kommun$KOMMUN2[cell])
#   }
#   else if("kommun" %in% as.vector(str_split_fixed(textcell3, pattern = " ", n = 10))){
#     kommun$KOMMUN2[cell] = textcell3
#     # print(kommun$KOMMUN2[cell])
#   }
#   else if("kommun" %in% as.vector(str_split_fixed(textcell4, pattern = " ", n = 10))){
#     kommun$KOMMUN2[cell] = textcell4
#     # print(kommun$KOMMUN2[cell])
#   }
#   else{
#     kommun$KOMMUN2[cell] = ""
#   }
# }


# save the result because it takes so much time !!!!!!!!
write.csv(kommun, 'C:/Users/ABC/Desktop//Uni Oldenburg//jobHUSE//Task_datacollection//Sweden//kommunListnames.csv', fileEncoding = 'UTF-8' )



############################################# CLEANING FOR municipality /kommun

# clean out all leading and trailing white spaces in the column KOMMUN2 and Call it KOMMUN1
kommun$KOMMUN1 <- trimws(kommun$KOMMUN2, which = c("both"))

# KOMMUN2 has greater than 996 unique values and KOMMUN1 has above 816 
# we still have dublicates where some have extra words that increases the number 
# of unique values - the correct value is 290 because there are only 290 
# kommunes in sweden 

# list of extra word in the column that must be deleted 
    # "/Skog"
    # "het"
    # "tidshus" - tidshus Forshaga kommun ?
    # "Sala kommun - "
    #  "- lantligt norr"
    # "Källna vid Össjö -" 
    # "övrigt"
    # " - lantligt söder"
    # " - lantligt norr"
    
unique(kommun$KOMMUN1)

# remove characters "/Skog " out of the column KOMMUN1 
kommun$KOMMUN1 <- gsub("/Skog ","",as.character(kommun$KOMMUN1))

# remove characters "het " out of the column KOMMUN1 
kommun$KOMMUN1 <- gsub("het ","",as.character(kommun$KOMMUN1))

# remove characters "tidshus " out of the column KOMMUN1 
kommun$KOMMUN1 <- gsub("tidshus ","",as.character(kommun$KOMMUN1))

# remove characters "Sala kommun - " out of the column KOMMUN1 
kommun$KOMMUN1 <- gsub("Sala kommun - ","",as.character(kommun$KOMMUN1))

# remove characters "Källna vid Össjö - " out of the column KOMMUN1 
kommun$KOMMUN1 <- gsub("Källna vid Össjö - ","",as.character(kommun$KOMMUN1))

# remove characters "övrigt" out of the column KOMMUN1 
kommun$KOMMUN1 <- gsub(" övrigt","",as.character(kommun$KOMMUN1))

# remove characters " - lantligt söder" out of the column KOMMUN1 
kommun$KOMMUN1 <- gsub(" - lantligt söder","",as.character(kommun$KOMMUN1))

# remove characters " - lantligt norr" out of the column KOMMUN1 
kommun$KOMMUN1 <- gsub(" - lantligt norr","",as.character(kommun$KOMMUN1))


# 6 instances left , 1) "" empty string, 2) lantligt norr, 3) lantligt söder

# replace lantligt söder with Sala kommun
kommun$KOMMUN1 <- replace(kommun$KOMMUN1, kommun$KOMMUN1 == "lantligt söder", "Sala kommun")

# replace lantligt norr with Sala kommun
kommun$KOMMUN1 <- replace(kommun$KOMMUN1, kommun$KOMMUN1 == "lantligt norr", "Sala kommun")

# replace Utby Göteborgs kommun with Göteborgs kommun
kommun$KOMMUN1 <- replace(kommun$KOMMUN1, kommun$KOMMUN1 == "Utby Göteborgs kommun", "Göteborgs kommun")

# replace Lövsjön Gagnef kommun with Gagnef kommun
kommun$KOMMUN1 <- replace(kommun$KOMMUN1, kommun$KOMMUN1 == "Lövsjön Gagnef kommun", "Gagnef kommun")

# replace Hässleholm kommun with Hässleholms kommun
kommun$KOMMUN1 <- replace(kommun$KOMMUN1, kommun$KOMMUN1 == "Hässleholm kommun", "Hässleholms kommun")

# replace Gagnef kommun with Gagnefs kommun
kommun$KOMMUN1 <- replace(kommun$KOMMUN1, kommun$KOMMUN1 == "Gagnef kommun", "Gagnefs kommun")





########################################## Cleaning for locality/ Urban area names- total 1956 urban ares, list:  https://en.wikipedia.org/wiki/List_of_urban_areas_in_Sweden
# delete leading and tailing white spaces
kommun$Locality <- trimws(kommun$Houseaddress_2, which = c("both"))

# remove different characters out of each value.

# "/Skog "
kommun$Locality <- gsub("/Skog ","",as.character(kommun$Locality))

" Green Village " 
kommun$Locality <- gsub(" Green Village ","",as.character(kommun$Locality))

# "het " 
kommun$Locality <- gsub("het ","",as.character(kommun$Locality))

# "tidshus "
kommun$Locality <- gsub("tidshus ","",as.character(kommun$Locality))

# "het Ale / "
kommun$Locality <- gsub("het Ale / ","",as.character(kommun$Locality))

# " /loo med omnejd"
kommun$Locality <- gsub(" /loo med omnejd","",as.character(kommun$Locality))

# "/Loo"
kommun$Locality <- gsub("/Loo","",as.character(kommun$Locality))

#"NOL" "Nol"   
nolList <- c("Nol", "NOL", )
kommun$KOMMUN1[kommun$KOMMUN1 == nolList] <- "Nödinge-Nol"

### _______________________> to much I bail on cleaning this - simply to much and not necessarily worth cleaning



# we are left with 291 municipality - this extra 1 is due to empty values. so far we cant
# figure out which municipalities these 541 rows are for - there fore i will merge the 
# column KOMMUN1 in kommun dataset into the dataset csvCollection and maybe there we can see more info

# add the kommun names in as new column 
csvCollection$Kommun_Name <- kommun$KOMMUN1

# add the 



# re arrange the new column so its with the other address columns.
csvCollection <- csvCollection[,c(1,2,3,4,22,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)]


# LOOK INTO ROWS WITH MISSIN VALUES IN COLUMN "Kommun_name"
emptyTest <- csvCollection[csvCollection$Kommun_Name=="",]$propertyID_hemnet

# TESTING TO FILL IN EMPTY CELLS OF Kommun_name
# index number of all rows with empty cells in Kommun_name
kommun_emptyList <- which(csvCollection$Kommun_Name == "")

for(i in 1:nrow(csvCollection[csvCollection$Kommun_Name == "",])){
  address2 <- csvCollection$houseAddress_2[kommun_emptyList[i]]
  print(address2)
  print(kommun_emptyList[i])
  
  #split the string by commas
  address2_split <- strsplit(address2,",")
  print(length(address2_split[[1]]))
  # find which  element has the word "kommun in it
  for(j in length(address2_split[[1]])){
    if(grepl("kommun",address2_split[[1]][j], fixed = TRUE) == TRUE){
      csvCollection$Kommun_Name[kommun_emptyList[i]] <- address2_split[[1]][j]
    }
  }
}

# delete all extra white spaces
csvCollection$Kommun_Name <- trimws(csvCollection$Kommun_Name, which = c("both"))




testrun <- csvCollection[kommun_emptyList,]
unique(testrun$Kommun_Name)


# # save file - for later use: 
# write.csv(csvCollection, 'C:/Users/ABC/Desktop//Uni Oldenburg//jobHUSE//Task_datacollection//Sweden//Hemnet_db_run2.csv', fileEncoding = 'UTF-8' )
# 
# # I was having issues running the hole code so I split it up in chunks by 
# # saving the changes 


###############################################################################
#
#             RUN 3: Hemnet_db_run3
# 
###############################################################################


# # Read in the file: 
# setwd("C:/Users/ABC/Desktop//Uni Oldenburg//jobHUSE//Task_datacollection//Sweden")
# hemnetData <- read.csv("Hemnet_db_run2.csv", encoding = "UTF-8")
hemnetData <- csvCollection

#================================================================#
#       Column: "...1" 
#================================================================#
# drop the column
hemnetData <- subset(hemnetData,select = c(-...1))

#================================================================#
#       Column: "Kommun_name" 
#================================================================#

# change name to "Municipality"
names(hemnetData)[names(hemnetData) == 'Kommun_Name'] <- 'Municipality'

# Delete the "kommun" in each cell
hemnetData$Municipality <- gsub("kommun","", as.character(hemnetData$Municipality))

# delete tailing and leading whitespaces
hemnetData$Municipality <- trimws(hemnetData$Municipality, which = c("both"))

#================================================================#
#       Column: "item_date_sold_at" 
#================================================================#
# change name to "Date_of_sale"
names(hemnetData)[names(hemnetData) == 'item_date_sold_at'] <- 'Date_of_sale'

# need to split the column into three columns by the white spaces then change the 
# month names into numbers- finally merge them into 1 column

# split column into 3 columns by whitespace
dateTest <- hemnetData %>% separate(Date_of_sale, c('DAY', 'MONTH', 'YEAR'))

# change month names (which are in swedish) into numbers 
monthNames <- unique(dateTest$MONTH)
monthNumber <- c(12,8,7,6,5,4,3,2,1,11,10,9)

for (i in 1:12) {
  dateTest$MONTH[dateTest$MONTH == monthNames[i]] <- monthNumber[i]
}

# combine three columns as a date column
dateTest$Date_of_sale <- as.Date(with(dateTest, paste(YEAR, MONTH, DAY,sep="-")), "%Y-%m-%d")

# Set the Date_of_sale from dateTest table into the original table hemnetData
# change Date_of_sale from hemnetdata into Date_of_sale_txt
names(hemnetData)[names(hemnetData) == 'Date_of_sale'] <- 'Date_of_sale_txt'
# add the Date_of_sale from dateTest table
hemnetData$Date_of_sale <- dateTest$Date_of_sale

# re-organize the columns- set Date of sale it in front
hemnetData <- hemnetData[,c(1,2,3,4,5,6,23,7,8,9,10,11,12,13,14,15,16,18,19,20,21,22)]
#================================================================#
#       Column: "item_finalprice" 
#================================================================#
# rename column to "Starting_price"
names(hemnetData)[names(hemnetData) == 'item_finalprice'] <- 'Final_price'

#================================================================#
#       Column: "item_utgangpris_child" 
#================================================================#

# rename column to "Starting_price"
names(hemnetData)[names(hemnetData) == 'item_Utgangpris_child'] <- 'Starting_price'

# Delete "kr" in each cell
hemnetData$Starting_price <- gsub(" kr","", as.character(hemnetData$Starting_price))
# delete the white space between numbers
hemnetData$Starting_price <- gsub(" ","", as.character(hemnetData$Starting_price))
# set column as a number 
hemnetData$Starting_price <- as.numeric(hemnetData$Starting_price) 


#================================================================#
#       Column: "item_Bostadstyp"  - Type of housing
#================================================================#

# change column name to Housing_type
names(hemnetData)[names(hemnetData) == 'item_Bostadstyp'] <- 'Housing_type'


unique(hemnetData$Housing_type)
table(hemnetData$Housing_type)

# swedish words for different type of housing: https://www.propertypriceadvice.co.uk/moving-home/housing-types-uk
# "Tomt"                  = Plot of land,   
# "Villa"                 = detached house,
# "Gård utan jordbruk"    = Farm without agriculture, 
# "Vinterbonat fritidshus"= Holiday Home,
# "Lägenhet"              = Apartment               
# "Övrig"                 = Other                  
# "Radhus"                = terraced                
# "Par-/kedje-/radhus"    = terraced    
#"Parhus"                 = semi-detached house                 
#"Kedjehus"               = terraced               
# "Gård/skog"             = farm/forest
# "Gård med jordbruk"     = farm with agriculture
# "Gård med skogsbruk"    = farm with forestry
# "Fritidshus"            = Holiday Home
# "Fritidsboende"         = Holiday Home

# change the swedish words for the english words 
HousingCategory_swedish <- unique(hemnetData$Housing_type)
HousingCategory_english <- c("Plot of land","detached house","Farm without agriculture","Holiday Home","Apartment","Other","terraced",
                             "terraced","detached house","terraced","farm/forest","farm with agriculture","farm with forestry","Holiday Home","Holiday Home")

for (i in 1:length(HousingCategory_swedish)) {
  hemnetData$Housing_type[hemnetData$Housing_type == HousingCategory_swedish[i]] <- HousingCategory_english[i]
}

unique(hemnetData$Housing_type)

#================================================================#
#       Column: item_Upplatelseform
#================================================================#

# rename to Tenure_type
names(hemnetData)[names(hemnetData) == 'item_Upplatelseform'] <- 'Tenure_type'

unique(hemnetData$Tenure_type)
table(hemnetData$Tenure_type)

# swedish words for different type of tenure: 
# "Äganderätt"               =  Ownership 
# "Bostadsrätt"              =  Right of residence
# "Information saknas"       =  Missing Info
# "Andel i bostadsförening"  =  Share in housing association
# "Annat"                    =  Other
# "Tomträtt"                 =  land Right
# "Andelsboende"             =  timeshare
# "Hyresrätt"                =  Right to rent

# change the swedish words for the english words

TenureCategory_swedish <- unique(hemnetData$Tenure_type)

TenureCategory_english <- c("Ownership","Right of residence","Missing Info","Share in housing association",
                            "Other","land Right","timeshare","Right to rent")

for (i in 1:length(TenureCategory_swedish)) {
  hemnetData$Tenure_type[hemnetData$Tenure_type == TenureCategory_swedish[i]] <- TenureCategory_english[i]
}

#================================================================#
#       Column: item_AntalRum
#================================================================#
# rename to Rooms i.e. number of rooms 
names(hemnetData)[names(hemnetData) == 'item_AntalRum'] <- 'Rooms'

unique(hemnetData$Rooms)
table(hemnetData$Rooms)# some properties have ridiculous  room values e.g. 85 or 90 rooms - looks like an typing error from hemnet. 

# delete the character "rum" in each cell
hemnetData$Rooms <- gsub(" rum","", as.character(hemnetData$Rooms))
# delete the white space between numbers
hemnetData$Rooms <- gsub(" ","", as.character(hemnetData$Rooms))

# change comma to dots 
hemnetData$Rooms <- str_replace_all(hemnetData$Rooms,",",".")

#================================================================#
#       Column: item_BoArea
#================================================================#

# Rename to Living_Area_m2 i.e. area in square meters of the property used to live in
names(hemnetData)[names(hemnetData) == 'item_BoArea'] <- 'Living_Area_m2'

unique(hemnetData$Living_Area_m2)
table(hemnetData$Living_Area_m2)# some properties have ridiculous  room values e.g. 85 or 90 rooms - looks like an typing error from hemnet. 

# delete the character "m²" in each cell
hemnetData$Living_Area_m2 <- gsub(" m²","", as.character(hemnetData$Living_Area_m2))

# change comma to dot: 
hemnetData$Living_Area_m2 <- str_replace_all(hemnetData$Living_Area_m2,",",".")

# remove ALL WHITE SPACE
hemnetData$Living_Area_m2 <- str_remove_all(hemnetData$Living_Area_m2, " ")

# convert column to numeric
hemnetData$Living_Area_m2 <- as.numeric(as.character(hemnetData$Living_Area_m2))

#================================================================#
#       Column: item_BiArea
#================================================================#

# taken from : https://hinative.com/questions/13012393
    # Area means area just like in english.
    # The prefix "by" means something like subsidiary.
    # Like "by" in english words like bylaw and byroad.
    # 
    # Biarea is the area of a home that are not used to live in.
    # Garage, boiler room, garbage room, attic storage etc. - balcony
    # 
    # "Bo" means to live (like inhabit).
    # Boarea is the area of the home that is used to live in.
    # Bedrooms, livingroom, bathroom etc.
    # 
    # There are rules about what counts as biarea and what is boarea.

# another link explaining this :https://www.quora.com/What-does-Boarea-Biarea-Land-Area-mean-for-a-property-in-Sweden

# Main link: https://www.ekonomifokus.se/bostad/bostadsrelaterat/boarea-och-biarea

# Rename to ancillary_area_m2 i.e. area of the property in square meters used for laundary, garbage room, garage etc.
names(hemnetData)[names(hemnetData) == 'item_Biarea'] <- 'Ancillary_Area_m2'

unique(hemnetData$Ancillary_Area_m2)
table(hemnetData$Ancillary_Area_m2)# some properties have ridiculous  room values e.g. 85 or 90 rooms - looks like an typing error from hemnet. 

# Delete the character " m²" from cells
hemnetData$Ancillary_Area_m2 <- gsub(" m²","", as.character(hemnetData$Ancillary_Area_m2))

# change comma to dot: 
hemnetData$Ancillary_Area_m2 <- str_replace_all(hemnetData$Ancillary_Area_m2,",",".")

# remove ALL WHITE SPACE
hemnetData$Ancillary_Area_m2 <- str_remove_all(hemnetData$Ancillary_Area_m2, " ")


#================================================================#
#       Column: item_Tomtarea
#================================================================#

# Rename to Lot_area_m2
names(hemnetData)[names(hemnetData) == 'item_Tomtarea'] <- 'Lot_area_m2'

unique(hemnetData$Lot_area_m2)
table(hemnetData$Lot_area_m2)

# Delete the character " m²" from cells
hemnetData$Lot_area_m2 <- gsub(" m²","", as.character(hemnetData$Lot_area_m2))

# change comma to dot: 
hemnetData$Lot_area_m2 <- str_replace_all(hemnetData$Lot_area_m2,",",".")

# remove ALL WHITE SPACE
hemnetData$Lot_area_m2 <- str_replace_all(hemnetData$Lot_area_m2, regex("\\s*"), "")

#================================================================#
#       Column: item_byggAr
#================================================================#
# rename to year_built
names(hemnetData)[names(hemnetData) == 'item_byggAr'] <- 'year_built'

#================================================================#
#       Column: item_Tomträttsavgäld
#================================================================#
# translation : Tomträttsavgäld -> Ground rent
# a ground rent is created when a freehold piece of land is sold on a long lease or leases
# link: https://www.boverket.se/sv/ekonomiska-planer/ekonomiska-planer-och-kostnadskalkyler/ekonomiska-planer/ekonomisk-plan-och-kostnadskalkyl4/tomtrattsavgald-och-arrendeavgift/

# rename to year_built
names(hemnetData)[names(hemnetData) == 'item_Tomträttsavgäld'] <- 'Ground_Rent_perYear'

unique(hemnetData$Ground_Rent_perYear)
table(hemnetData$Ground_Rent_perYear)

# Remove character "kr/ar/ar"
hemnetData$Ground_Rent_perYear <- gsub("kr/år/år","", as.character(hemnetData$Ground_Rent_perYear))

# remove ALL WHITE SPACE
hemnetData$Ground_Rent_perYear <- str_replace_all(hemnetData$Ground_Rent_perYear, regex("\\s*"), "")

#================================================================#
#       Column: item_Driftskostnad
#================================================================#
# Driftskostnad in english is "operating_cost" 

# change name to Operating_cost_peryear
names(hemnetData)[names(hemnetData) == 'item_Driftskostnad'] <- 'Operating_Cost'

unique(hemnetData$Operating_Cost)
table(hemnetData$Operating_Cost)

# Remove character "kr/ar"
hemnetData$Operating_Cost <- gsub("kr/år","", as.character(hemnetData$Operating_Cost))

# remove ALL WHITE SPACE
hemnetData$Operating_Cost <- str_replace_all(hemnetData$Operating_Cost, regex("\\s*"), "")

#================================================================#
#       Column: item_Balkong
#================================================================#

# Rename  to Balcony_dummy
names(hemnetData)[names(hemnetData) == 'item_Balkong'] <- 'Balcony_Dummy'

unique(hemnetData$Balcony_Dummy)
table(hemnetData$Balcony_Dummy)

# rename values "ja" to 1 and "nej" to 0 
hemnetData$Balcony_Dummy[hemnetData$Balcony_Dummy == 'Ja']  <- 1
hemnetData$Balcony_Dummy[hemnetData$Balcony_Dummy == 'Nej'] <- 0

#================================================================#
#       Column: item_Vaning
#================================================================#

#Here the column must be split into 3 columns: 
    # floor - what floor the aprartment is on
    # total Floors - the total floors in the building
    # Elevator dummy - 0 or 1 if there is an elevator in the building
    # for estates that dont have any floors or elevator will have the value NULL in floor, NULL in total floors and and 0 in Elevator dummy
unique(hemnetData$item_Vaning)
table(hemnetData$item_Vaning)

# change zero values to NULL 
hemnetData$item_Vaning[hemnetData$item_Vaning == '0']  <- "NULL"

# Remove character "av"
hemnetData$item_Vaning <- gsub("av","", as.character(hemnetData$item_Vaning))

#remove double whitespace
hemnetData$item_Vaning <- str_squish(hemnetData$item_Vaning)

# split item vaning into two columns floor, total floor then elevator
hemnetData[c("Floor_TotalFloor","Elevator_dummy")] <- str_split_fixed(hemnetData$item_Vaning, ", ",2)

# Split Floor_TotalFloor into Floor and Total_Floors columns by whitespace
hemnetData[c("Floor","Total_Floors")] <- str_split_fixed(hemnetData$Floor_TotalFloor, " ",2)
unique(hemnetData$Floor)
unique(hemnetData$Total_Floors)

# change column Elevator_dummy into dummy variable - "hiss finns" has elevator and "hiss finns ej" doesnt have elevator
unique(hemnetData$Elevator_dummy)
table(hemnetData$Elevator_dummy)
hemnetData$Elevator_dummy[hemnetData$Elevator_dummy == "hiss finns ej"] <- 0
hemnetData$Elevator_dummy[hemnetData$Elevator_dummy == "hiss finns"] <- 1
#also change empty cells into zeros
hemnetData$Elevator_dummy[hemnetData$Elevator_dummy == ""] <- 0


#Drop columns: "item_Vaning" & "Floor_TotalFloor" 
dropColumn <- c('item_Vaning','Floor_TotalFloor')
hemnetData <- hemnetData[,!names(hemnetData) %in% dropColumn]

#Change Columns: Floor & Total_floors into numeric columns
# change comma to dot in Floor column: 
hemnetData$Floor <- str_replace_all(hemnetData$Floor,",",".")
# Change Floor column to numeric
hemnetData$Floor <- as.numeric(as.character(hemnetData$Floor))
unique(hemnetData$Floor)
# Change Floor column to numeric - no need to change comma to dot - all values are integer
hemnetData$Total_Floors <- as.numeric(as.character(hemnetData$Total_Floors))
unique(hemnetData$Total_Floors)



#================================================================#
#       Column: item_Uteplats
#================================================================#
unique(hemnetData$item_Uteplats)
table(hemnetData$item_Uteplats)

# uteplats means patio area, if 0 then the estate doenst have a patio area, if "Ja" then it does
# Change "Ja" into 1 - making this column a dummy variable
hemnetData$item_Uteplats[hemnetData$item_Uteplats == 'Ja']  <- 1

# Rename column into patio_dummy
names(hemnetData)[names(hemnetData) == 'item_Uteplats'] <- 'Patio_dummy'

unique(hemnetData$Patio_dummy)
table(hemnetData$Patio_dummy)

#================================================================#
#             Rearrange columns 
#================================================================#
# re-arrange the columns: "Elevator_dummy", 'Floor' and 'Total_floors'
hemnetData <- hemnetData[,c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22,23,21,19,20,24)]

#================================================================#
#             Add latitude and longitude
#================================================================#
# #install.packages('tidygeocoder')
# library(tidygeocoder)
# 
# testbind <- fulldata %>% unite(FullAddress, houseAddress_1:houseAddress_2, sep = ",")
# testbind1 <- fulldata %>% select(houseAddress_1,houseAddress_2, Municipality)
# testbind1$fullAddress <- testbind$FullAddress
# 
# FullAddress <- testbind1$fullAddress
# FullAddress[1]
# 
# 
# fullAddressMini <- testbind1[1:10,]
# fullAddressMini
# 
# # drop all NA 
# fullAddressMini$fullAddress <- gsub("NA,","", as.character(fullAddressMini$fullAddress))
# fullAddressMini$fullAddress <- gsub(",NA","", as.character(fullAddressMini$fullAddress))
# fullAddressMini$fullAddress <- gsub("NA","", as.character(fullAddressMini$fullAddress))
# 
# fullAddressMini
# 
# 
# 
# # get coordinates
# lat_longs <- hemnetData %>%
#   geocode(houseAddress_2, method = 'osm', lat = latitude , long = longitude)
# 
# lat_longs
# 
# 
# setwd('C:/Users/ABC/Desktop//Uni Oldenburg//jobHUSE//Task_datacollection//Sweden')
# fulldata <- read.csv("Hemnet_FINAL_db.csv", encoding = "UTF-8")
# 
# 
# testbind1half1 <- testbind1[1:716150,]
# testbind1half2 <- testbind1[1:716151,]
# 
# write.csv(testbind1half1, 'C:/Users/ABC/Desktop//Uni Oldenburg//jobHUSE//Task_datacollection//Sweden//testbind1half1.csv', fileEncoding = 'UTF-8' )
# write.csv(testbind1half2, 'C:/Users/ABC/Desktop//Uni Oldenburg//jobHUSE//Task_datacollection//Sweden//testbind1half2.csv', fileEncoding = 'UTF-8' )

#================================================================#
#             Remove duplicate Data
#================================================================#
# any duplicate data? 
any(duplicated(hemnetData$link)) #TRUE

# remove duplicates based on Link column
hemnetData_nodub<- hemnetData[!duplicated(hemnetData$link), ]

# we go from having 1.432.301 to having 1.022.169 observations

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##################################################################
#================================================================#
#              Save as the FINAL dataset! 
#================================================================#
##################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# delete the indexies 
hemnetData_nodub <- subset(hemnetData_nodub,select = c(-X.1, -X))

write.csv(fulldata_nodub, 'C:/Users/ABC/Desktop//Uni Oldenburg//jobHUSE//Task_datacollection//Sweden//Hemnet_FINAL_db.csv', fileEncoding = 'UTF-8' )

















