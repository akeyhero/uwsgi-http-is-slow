FROM python:3.8.2-slim-buster AS base

RUN apt-get update && apt-get install -y gcc

COPY requirements.txt /
RUN pip install -r /requirements.txt

COPY uwsgi.ini /

WORKDIR /app
COPY app /app

CMD ["flask", "run", "--host=0.0.0.0"]
