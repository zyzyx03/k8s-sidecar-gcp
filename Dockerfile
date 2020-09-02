from python:3.8

MAINTAINER zyzyx

COPY . /app

WORKDIR /app

RUN pip install pipenv

RUN pipenv install --system --deploy --ignore-pipfile

#ENV DB_USER "something"
#ENV DB_PASS "something"
#ENV DB_NAME "something"
#ENV SECRET_KEY "something"
#ENV DB_HOST "something"

CMD ["python", "app.py"]

