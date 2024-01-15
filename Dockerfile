FROM python:3.9

# Install Apache and dependencies
RUN apt-get update && apt-get install -y apache2 && a2enmod rewrite

# Set the working directory
WORKDIR /app

# Copy the application code to the container
COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Expose ports
EXPOSE 80 443 

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
