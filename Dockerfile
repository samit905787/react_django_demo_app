FROM python:3.9
WORKDIR /app
COPY . /app
# Create a directory for SSL files and copy them
RUN mkdir /dockerssl
COPY certificate.crt /dockerssl/
COPY private.key /dockerssl/
RUN pip install -r requirements.txt 
EXPOSE 8001
CMD ["python","manage.py","runserver","0.0.0.0:8001", "--certfile=/app/certificate.crt", "--keyfile=/app/private.key"]

