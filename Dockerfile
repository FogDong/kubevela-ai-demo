FROM jupyter/scipy-notebook

WORKDIR /workspace

RUN mkdir /workspace/my-model

COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt 

COPY train.csv ./train.csv
COPY test.json ./test.json

COPY train.py ./train.py
COPY api.py ./api.py

RUN python3 train.py
