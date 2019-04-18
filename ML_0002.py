from sklearn import svm, metrics
import pandas as pd
from sklearn.model_selection import GridSearchCV, train_test_split

# 데이터 읽기
csv = pd.read_csv('./data/iris.csv')       # csv[:4] : 0 ~ 4행
cdata = csv[['SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth']]
cret = csv['Name']

trainData, testData, trainLabel, testLabel = train_test_split(cdata, cret)

# grid-search 를 통한 최적값 찾기
params = [
    {"C": [1, 10, 100, 1000], "kernel": ['linear']},
    {"C": [1, 10, 100, 1000], "kernel": ['rbf'], "gamma": [0.01, 0.001, 0.0001]},
]
clf = GridSearchCV(svm.SVC(), params, n_jobs = -1, cv = 3, iid=True)

# 훈련
clf.fit(trainData, trainLabel)  

# 검증
pred = clf.predict(testData)    
score = metrics.accuracy_score(testLabel, pred)
print("best score >>>>", score)

# 최적값
print("machine=", clf.best_estimator_)

# 최적값을 이용한 재확인
clf = svm.SVC(C=1, cache_size=200, class_weight=None, coef0=0.0,
  decision_function_shape='ovr', degree=3, gamma='auto_deprecated',
  kernel='linear', max_iter=-1, probability=False, random_state=None,
  shrinking=True, tol=0.001, verbose=False)

# 최적값을 이용한 훈련
clf.fit(trainData, trainLabel)

# 최적값을 이용한 검증
pred = clf.predict(testData)
score = metrics.accuracy_score(testLabel, pred)
print("score(using recommandation) >>> ", score)

# 사용자 확인
t = [(5.1,3.5,1.4,0.2)] 
r = clf.predict(t)
print(t[0], "user test >>>>", r[0])
