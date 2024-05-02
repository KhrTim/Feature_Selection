import os
import pandas as pd
import numpy as np
import scipy.io as sio
from sklearn.preprocessing import LabelEncoder

# read csv and change ? to nan and label encoding
data_path = "./data/"
data_name = "audiology.csv"

# read csv
df = pd.read_csv(os.path.join(data_path, data_name), header=None)

# if there is ? in the data, then change it to do impuation
df = df.replace("?", np.nan)

# mode impuation
df = df.fillna(df.mode().iloc[0])


fea = df.iloc[:, :-1]
gnd = df.iloc[:, -1]
# label encoding


# label encoding without NaN
# if each column has more than 2 unique values, then one-hot encoding by numbers
# if each column has 2 unique values, then label encoding
# if each column has 1 unique value, then drop this column
for col in fea.columns:
    if fea[col].nunique() > 10:
        fea = fea.drop([col], axis=1)
        col = col - 1
    if fea[col].nunique() > 2:
        fea = pd.get_dummies(fea, columns=[col])
    elif fea[col].nunique() == 2:
        fea[col] = LabelEncoder().fit_transform(fea[col].astype(str))
    else:
        fea = fea.drop([col], axis=1)

# drop columns
# label encoding to all columns

for col in fea.columns:
    fea[col] = LabelEncoder().fit_transform(fea[col].astype(str))

# label endcoding to gnd
gnd = LabelEncoder().fit_transform(gnd.astype(str))

# save matlab .mat file
sio.savemat(
    os.path.join(data_path, data_name.split(".")[0] + ".mat"),
    {"fea": fea.values, "gnd": gnd},
)
