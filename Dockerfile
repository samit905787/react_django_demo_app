FROM python:3.9
WORKDIR /app
COPY . /app
# Copy SSL certificate and key
COPY . /dockerssl/certificate.crt /app/
COPY . /dockerssl/private.key /app/
RUN pip install -r requirements.txt 
EXPOSE 8001
CMD ["python","manage.py","runserver","0.0.0.0:8001", "--certfile=/app/certificate.crt", "--keyfile=/app/private.key"]

