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

- `-t` - flag tags the image with a name — in this case, `backend-flask`.
- `./backend-flask` - This is the build context. Basically the folder where Docker should look for a `Dockerfile` and all the necessary files (like app code, requirements.txt, etc.).


So Docker will:
- Look inside `./backend-flask/` folder
- Find a `Dockerfile`
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
- `-d`: Runs the container in the background 

### Get container images or running container ids
```yml
docker ps # shows running containers
docker image ls # show all top level images, their repository and tags, and their size.
```

#### Store the container image as an env variable
- This is good practice so that you don't have to run `docker ps` everytime you want to use the container ID
- To do so, run

```yml
CONTAINER_ID=$(docker run -rm -p 4567:4567 backend-flask)
```
### View container logs 
```
docker logs $CONTAINER_ID -f
```
`$CONTAINER_ID` - The set environment variable containing the actual container ID
`-f` - continues to follow/stream the logs in real time.


### Gain access to a container
To gain access to a container and run commands in it, run:

```yml
docker exec -it $CONTAINER_ID /bin/bash
```
- `docker exec`: Run a command inside a running container.

- `-it`: Allows interactive mode with a TTY (so you can use the shell like normal).

- `$CONTAINER_ID`: A shell variable containing the container ID or name.

- `/bin/bash`: The command you want to run inside the container (launches a Bash shell).


## Containerize the frontend

### Run npm install
`npm install` is a command used for `node.js` projects to install dependencies. It reads the `package.json` file and installs the specified packages, including their dependencies in the `node_modules` folder.

```
npm install
```


### Add a Dockefile
In the `frontend-react-js` folder, add a `Dockerfile` and write the following commands in the dockerfile.

```dockerfile
FROM node:16.18

ENV PORT=3000

COPY . /frontend-react-js
WORKDIR /frontend-react-js
RUN npm install
EXPOSE ${PORT}
CMD ["npm", "start"]
```

### Build the container
```yml
docker build -t frontend-react-js ./frontend-react-js
```

### Run the container
```yml
docker run -d -p 3000:3000 frontend-react-js -it
```

- Open port 3000 from the ports tab to confirm that indeed your container is running.

So far we have two separate running containers of the same application. We need these two containers to run as a 'single' container which is our application. To do this, we will use `docker compose`<br>

Docker compose - Docker Compose is a tool for defining and running multi-container applications. It is the key to unlocking a streamlined and efficient development and deployment experience <br>




