setwd("C:/Users/USER/Desktop/練習_lesson/10")
doc <- "Today is a wonderful day.  What do you think?"
#使用gsub取代特定詞彙,做字串清理
gsub("T", "A", doc)
gsub("[.]|[?]", "", doc)
strsplit(doc," ")

#讀取自訂的stopwords
stop_en <- read.table(file="Stop_En.txt", header = FALSE, sep=",")
stop_en <- as.character(stop_en)

#定義一個可以做大小寫轉換,將stopword去除,strsplit指定空格切出各獨立詞彙,製作token的function
tokenization <- function(x){
  x <- tolower(x)
  x <- gsub("[.]|[?]|[!]|[:]", "", x)
  for(i in 1:length(stop_en)){
     x <- gsub(stop_en[i], " ", x)
  }
  x <- unlist(strsplit(x, " "))
  
  t <- NULL
  for(i in 1:length(x)){
    if(x[i] != "") t <- c(t, x[i])
  }
  return(t)
}

doc1 <- "What is text mining?"
token1 <- tokenization(doc1)
token1
#"what"   "text"   "mining"

doc2 <- "I am not sure."
token2 <- tokenization(doc2)
token2
#"sure"

doc3 <- "I like learning interesting skills."
token3 <- tokenization(doc3)
token3
#"like"    "learning"    "interesting" "skills"   

doc4 <- "Text mining is the trend. Mining is great."
token4 <- tokenization(doc4)
token4
#"text"   "mining" "trend"  "mining" "great"

#載入專門處理的套件
install.packages('SnowballC')
library(SnowballC)
stem1 <- wordStem(token1, language = "english")
stem2 <- wordStem(token2, language = "english")
stem3 <- wordStem(token3, language = "english")
stem4 <- wordStem(token4, language = "english")

#建立corpus儲存所有文檔的token
corpus <- list(stem1, stem2, stem3, stem4)
#建立bag of words
bag <- unique(c(stem1, stem2, stem3, stem4))
corpus
bag

#建立tf表格,以bag中的詞彙為欄位名,預設值都為0
tf <- matrix(0,nrow=length(corpus), ncol=length(bag), dimnames=list(NULL, bag))
tf

corpus[[4]]
#"text"  "mine"  "trend" "mine"  "great"

bag
#"what"  "text"   "mine"   "sure"   "like"   "learn"  "interest" "skill"  "trend"  "great"   

match(corpus[[1]], bag) #123
match(corpus[[2]], bag) #4
match(corpus[[3]], bag) #5678
match(corpus[[4]], bag) #239310 對應到bag中排序2,3,9,3,10的詞

#查看第四個文檔的詞頻分布(只顯示出現那些字,沒有累計出現次數)
new.tf1 <- tf
matchID <- match(corpus[[4]], bag)
new.tf1[4, matchID] <- 1
new.tf1
#累計出現次數
new.tf2 <- tf
matchID <- match(corpus[[4]], bag)
len <- length(matchID)
for(j in 1:len){
  new.tf2[4, matchID[j]] <- (new.tf2[4, matchID[j]] + 1)
}
new.tf2

#對所有文檔做tf詞頻
new.tf1 <- tf
new.tf2 <- tf
for(i in 1:length(corpus)){
  matchID <- match(corpus[[i]], bag)
  len <- length(matchID)
  for(j in 1:len){
    new.tf1[i, matchID[j]] <- 1
    new.tf2[i, matchID[j]] <- (new.tf2[i, matchID[j]] + 1)
  }
}
new.tf1
new.tf2

#計算tfidf(考慮詞頻與該字彙代表性)
colSums(new.tf1)
idf <- 1 + log(nrow(new.tf1)/colSums(new.tf1))
idf

tfidf <- new.tf2
for(word in names(idf)){
  tfidf[,word] <- tfidf[,word] * idf[word]
}
tfidf


#查看文檔相似度,使用cosine計算
v1 <- tfidf[1,]
v4 <- tfidf[4,]
v14 <- sum(v1 * v4)
v11 <- sqrt(sum(v1 * v1))
v44 <- sqrt(sum(v4 * v4))
d_cosin <- 1 - (v14 / (v11 * v44))
d_cosin

#繪製wordcloud
install.packages('wordcloud')
library(wordcloud)
wordCount <- colSums(new.tf2)
words <- names(wordCount)
wordcloud(words, wordCount)

#載入結巴,處理中文文檔
library(jiebaR)
seg <- worker()
ex1 <- "你品嚐了夜的巴黎，你穿越了風的新竹"
ex2 <- "江州市長江大橋參加了長江大橋的通車儀式"
ex3 <- "全台大停電"
segment(ex1, seg) #"你" "品嚐" "了" "夜" "的" "巴黎" "你" "穿越" "了" "風" "的" "新竹"
segment(ex2, seg) # "江州" "市" "長江大橋" "參加" "了" "長江大橋""的" "通車" "儀式"  
segment(ex3, seg) #"全" "台大" "停電"


#重新載入,加上自訂stopword
edit_dict()
seg <- worker()
ex4 <- "這個你品嚐了夜的巴黎，你穿越了風的新竹"
segment(ex4, seg)# "這個""你" "品嚐" "了" "夜" "的""巴黎" "你" "穿越""了""風""的""新竹"
seg <- worker(stop_word = "Stop_Tw.txt")
segment(ex4, seg)#"品嚐" "巴黎" "穿越" "新竹"
