FROM python:3

WORKDIR /src
COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt
COPY . .

ENTRYPOINT [ "python","run.py" ]