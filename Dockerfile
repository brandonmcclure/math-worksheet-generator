FROM python:3 as base

WORKDIR /src
COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt
COPY . .

RUN python -m unittest /src/tests/*

ENTRYPOINT [ "python","run.py" ]