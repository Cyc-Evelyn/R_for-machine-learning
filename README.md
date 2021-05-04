# R_for-machine-learning
using R to learn ML  
#learning structure  
(1)overfitting : 如何訓練模型才能最大泛化且精準  
使用train, test, valid 作驗證與調整參數, 讓參數找到最佳泛化解    

(2)cluster :分群希望群內最像,群外最不像,用距離衡量  
如何衡量距離? ex. euclidean distance, 曼哈頓 ,jaccard ,cosine...  
分群應用 : 將很像的個體作預測 ex.不同時段的車流量,客戶流失,客戶喜好,搜尋引擎...  

(3)probabilities : 說明機器學習原理,使用一連串條件判斷 ex. bayes  

(4)confusion matrix : 衡量模型表現  
ex. FP,TP,FN,TN 需考量預測的目標來說,何項指標較重要並以該指標來優化  
ex. EV(Expect Value) 計算各情境的可得的價值總和,比如衡量促銷是否划算  
ex. MAPE,RMSE  

(5)ROC繪製: 將模型表現視覺化  

(6)Associate : 如何分辨不是隨機發生的事件(兩者無關只是剛好一起發生)  
ex.lift ,leverage訊息增益法  
ex.support P(A|B)  
ex.strength P(A,B)  
  
發生的頻率: ex.FPM頻繁樣態探勘(使用門檻值決定是否要納入關聯規則分析)  
但這樣也會排除高價但低頻的購買商品,應同時考慮頻率&價值  
ex. MIS Apriori (不同種類商品有不同頻率門檻值)




