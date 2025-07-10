# Containerize the application

## Containerize the backend

### Add Dockefile
- In the `backend-flask` folder, create a `Dockerfile`.
- A `Dockerfile` is a text file containing a set of instructions used to automate the creation of a docker image. It acts as a blueprint for building the image, and specifies what base image to use and how to configure it.
- A `docker image` is a read-only template that contains the application code, the runtime, libraries, dependencies, and other files needed to run an application

```yml
FROM python:3.10-slim-buster # This is the base image we are building from. Ground zero

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
```
### Build the container
```yml
docker build -t backend-flask ./backend-flask
```

`-t` - flag tags the image with a name — in this case, `backend-flask`.
`./backend-flask` - This is the build context. Basically the folder where Docker should look for a `Dockerfile` and all the necessary files (like app code, requirements.txt, etc.).
So Docker will:

- Look inside ./backend-flask/

- Find a Dockerfile

- Follow the instructions in that Dockerfile to build the image

### Run the container

```yml
docker run --rm -d -p 4567:4567 -it -e FRONTEND_URL="*" -e BACKEND_URL="*" backend-flask
```

- `--rm`: Automatically removes the container after it stops (no leftover containers).

- `-p 4567:4567`: Maps port 4567 inside the container to port 4567 on your local machine.

- `-it`: Runs the container interactively (e.g., so you can see logs or use a shell).

- `-e FRONTEND_URL="*" & -e BACKEND_URL="*"`: Sets environment variables inside the container.

- `backend-flask`: The name of the image you are running.