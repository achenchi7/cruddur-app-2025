FROM python:3.10-slim-buster

# Inside the container
# Makes a new folder inside the container
WORKDIR /backend-flask

# Copies outside the container -> inside the container
# This file contains all the libraries we want to install to run the app
COPY requirements.txt requirements.txt

# Inside the container
# Install the python libraries used for the app
RUN pip3 install -r requirements.txt

# Outside the container -> Inside the container
# "." means everything in the current directory
# first period . /backend-flask (outside container)
# second period . /backend-flask (inside container)
COPY . .

# Set env vars inside the container and will remain set when the container is running
ENV FLASK_ENV=development

EXPOSE ${PORT}

# CMD (Command)
# python 3 -m flask run --host=0.0.0.0 --port=4567
CMD [ "python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=4567" ]
