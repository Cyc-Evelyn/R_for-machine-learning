setwd("C:/Users/USER/Desktop/CrawlerofPTT")
library(XML)
library(RCurl)
library(tm)
library(jiebaR)

#取得國際看板的3170~3172頁內容
link <- NULL
for( i in 3170:3172){
  url <- paste0("https://www.ptt.cc/bbs/IA/index",i, ".html")
  html <- htmlParse(getURL(url))
  url.list <- xpathSApply(html, "//div[@class='title']/a[@href]", xmlAttrs)
  link <- c(link, paste('https://www.ptt.cc', url.list, sep=''))
}
length(link) #共60篇

article <- NULL
html <- htmlParse(getURL(link[5]))
doc <- xpathSApply(html,"//div[@id='main-content']", xmlValue)
doc 

#文檔清理
for(i in 1:length(link)){
  Sys.sleep(runif(1,1,2))
  html <- htmlParse(getURL(link[i]))
  doc <- xpathSApply(html, "//div[@id='main-content']", xmlValue)
  doc <- removePunctuation(doc)
  doc <- gsub("[A-Za-z0-9]", "", doc)
  doc <- gsub(" ", "", doc)
  doc <- gsub("\n", "", doc)
  doc <- gsub("。", "", doc)
  doc <- gsub(":", "", doc)
  doc <- gsub("，", "", doc)
  doc <- gsub("→", "", doc)
  article[i] <- doc
}

length(article) #3172

#使用結巴斷詞+STOPWORD
seg <- worker(stop_word="Stop_Tw.txt")
corpus <- NULL
for(i in 1:length(article)){
  corpus[[i]] <- segment(article[i], seg)
}

union <- NULL
for(i in 1: length(article)){
  union <- c(union, corpus[[i]])
}

bag <- unique(union)
length(union)#43672
length(bag)#9081個不重複的詞彙

tf <- matrix(0, nrow=length(article), ncol=length(bag),dimnames=list(NULL,bag))
for(i in 1:length(article)){
  tf[i, match(corpus[[i]], bag)] <- 1
}

tf_count <- colSums(tf)
tf_count <- sort(tf_count, decreasing = TRUE)
tf_count[1:10] #查看最常出現的十個詞
#查看新聞與各詞的相關性
cor_term <- cor(tf)
cor_guardian <- cor_term["新聞",]
cor_guardian <- sort(cor_guardian, decreasing = TRUE)
cor_guardian[50] #清玉案
