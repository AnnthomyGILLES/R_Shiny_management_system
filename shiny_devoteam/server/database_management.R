# ########################
#  ATTENTION
# ########################

database_url <-
  "mongodb+srv://ctreand:bLpLUyw1VuIsIjvg@devoteamdrm-pmkgc.gcp.mongodb.net/test?retryWrites=true"

collectionName <- "DRMforms"

# Connexion à la base de données Mongodb
db <-
  mongolite::mongo(collection = collectionName,
                   url = database_url,
                   db = "test")

admin_db <-
  mongolite::mongo(collection = "admin_db",
                   url = database_url,
                   db = "test")

managers_db <- mongolite::mongo(collection = "managers_db",
                             url = database_url,
                             db = "test")
  
sales_db <-
  mongolite::mongo(collection = "sales_db",
                   url = database_url,
                   db = "test")

consultants_db <-
  mongolite::mongo(collection = "consultants_db",
                   url = database_url,
                   db = "test")


find_in_database <- function(database , query, fields = '{}', ...) {
  df <- database$find(query = query, fields = fields, ...)
  return(df)
}

