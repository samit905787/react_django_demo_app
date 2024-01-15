FROM python:3.9
# Install Apache and Certbot for Apache
RUN apt-get update && apt-get install -y
WORKDIR app
COPY . /app
RUN pip install -r requirements.txt 
EXPOSE 8001 80 443
CMD ["python","manage.py","runserver","0.0.0.0:8001"]
# Start Apache or your application, adjust as needed
CMD ["apache2ctl", "-D", "FOREGROUND"]
