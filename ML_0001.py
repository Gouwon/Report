from sklearn import svm, metrics
import pandas as pd
from sklearn.externals import joblib
from pathlib import Path

def readCsv(file, maxcnt):
    labels = []
    images = []
    with open(file, "r") as f:
        for i, line in enumerate(f):
            if i >= maxcnt:
                break
            cols = line.split(",")
            labels.append(int(cols.pop(0)))      # 첫번째 자리가 label
            images.append(list(map(lambda b: int(b) / 256, cols)))  # 실수 벡터화
    return {"labels": labels, "images": images}


train = readCsv('./data/train.csv', 60000)   # 학습용 데이터가 많아질수록 스코어 상승!
test = readCsv('./data/t10k.csv', 10000)

# print(test['images'])

pklFile = './data/mnist.pkl'
clf = None       # 초기화
if Path(pklFile).exists():              # from pathlib import Path
    clf = joblib.load(pklFile)

if not clf:
# training ---------------------------
    train = readCsv('./data/train.csv', 60000)
    clf = svm.SVC(gamma='auto')
    clf.fit(train['images'], train['labels'])
    joblib.dump(clf, pklFile)



# test -------------------------
pred = clf.predict(test['images'])

score = metrics.accuracy_score(test['labels'], pred)
print("\n\nscore=", score)

print("-----------------------------------------")
report = metrics.classification_report(test['labels'], pred)
print(report)
