library(rJava)
# install.packages(c("NLP", "openNLP", "RWeka", "qdap"))
# install.packages("openNLPmodels.en",
#                 repos = "http://datacube.wu.ac.at/",
#                 type = "source")

library(NLP)
library(openNLP)
library(RWeka)
library(magrittr)
library(stringr)
library(readxl)
work <- read_excel("C:/Users/barsa/Downloads/work.xlsx", sheet = "89")
View(work)

test <- work[,c(1,2,49)]
options(java.parameters = "- Xmx2048m")


test$`Task Comments` <- str_replace_all(test$`Task Comments`, "-", " ")

test_up1 <- test[is.na(test$`Task Comments`) == FALSE,]

  test_up <- test_up1[1:5,]
  
for (i in 3:3) {
bio <- test_up[i,3]

View(bio)

bio <- as.String(bio)

word_ann <- Maxent_Word_Token_Annotator()
sent_ann <- Maxent_Sent_Token_Annotator()

bio_annotations <- annotate(bio, list(sent_ann, word_ann))
class(bio_annotations)
head(bio_annotations)

bio_doc <- AnnotatedPlainTextDocument(bio, bio_annotations)



person_ann <- Maxent_Entity_Annotator(kind = "person")

location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")



pipeline <- list(sent_ann,
                 word_ann,
                 person_ann,
                 location_ann,
                 organization_ann)
bio_annotations <- annotate(bio, pipeline)
bio_doc <- AnnotatedPlainTextDocument(bio, bio_annotations)


entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}


t1<- data.frame(as.list(entities(bio_doc, kind = "person")))



t2<- entities(bio_doc, kind = "location")


t3 <- data.frame(as.list(entities(bio_doc, kind = "organization")))

comb <- paste( unlist(t1), collapse=',')

test_up[i,4] <- comb

remove(person_ann,location_ann,organization_ann)

}

