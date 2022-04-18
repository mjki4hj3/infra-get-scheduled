FROM python:3

RUN pip install --upgrade pip

WORKDIR /hello_world

COPY requirements.txt .

RUN pip3 install -r requirements.txt

COPY . .

CMD ["gunicorn", "-b", "0.0.0.0:8000", "hello:app"]