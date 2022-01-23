FROM jupyter/scipy-notebook

RUN mkdir my-model

ENV MODEL_DIR=/home/jovyan/my-model
ENV MODEL_FILE_LDA=clf_lda.joblib
ENV MODEL_FILE_NN=clf_nn.joblib

COPY src/requirements.txt requirements.txt
RUN pip install -r requirements.txt 

COPY src/train.csv train.csv
COPY src/test.json test.json

COPY src/train.py train.py
COPY src/api.py api.py

RUN python3 train.py
