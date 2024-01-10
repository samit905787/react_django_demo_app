FROM python:3.9

WORKDIR /app

# Copy application code
COPY . /app/

# Create a directory for SSL files and copy them from the host
RUN mkdir /app/dockerssl
COPY /home/azureuser/dockerssl/ca_bundle.crt /app/dockerssl/
COPY /home/azureuser/dockerssl/certificate.crt /app/dockerssl/
COPY /home/azureuser/dockerssl/private.key /app/dockerssl/

# Install dependencies
RUN pip install -r requirements.txt

# Expose the port
EXPOSE 8001

# Run the application with SSL
CMD ["python", "manage.py", "runserver", "0.0.0.0:8001", "--certfile=/app/dockerssl/certificate.crt", "--keyfile=/app/dockerssl/private.key"]
