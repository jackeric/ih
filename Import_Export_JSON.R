library(dplyr)
library(jsonlite)

##### Get list of batches #####
url = "https://secure.ordyx.com/OrderExport.jsp?store_id=263&password=rFDTuXLzspqC&getBatches=true"
batches <- fromJSON(url)
library(RJSONIO)
exportJson <- toJSON(batches)
write(exportJson, "batches.json")
maxBatch <- as.integer(max(batches[,2]))

# other counters
minBatch = 0
rowsAllowed = 9
j = 0

##### Get data files #####
# pipes all data if jsonData is empty
for (i in 1:maxBatch) {
    # get single json file
    library(jsonlite)
    url <- paste("https://secure.ordyx.com/OrderExport.jsp?store_id=263&password=rFDTuXLzspqC&min_batch_id=",
    as.character(minBatch),"&max_batch_id=",as.character(minBatch+rowsAllowed), collapse="")
    url <- gsub(" ","",url)
    jsonTemp <- fromJSON(url)
    # export single json file
    library(RJSONIO)
    exportJson <- toJSON(jsonTemp)
    path <- paste(as.character(j),".json", collapse="")
    path <- gsub(" ","",path)
    write(exportJson, path)
    # updates
    i = i+rowsAllowed
    j = j+1
}
