# README #

![Robot framework](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Robot-framework-logo.png/250px-Robot-framework-logo.png)

Robot Framework API automation example

### How do I get set up? ###

* Install [Python 3](https://python.org/)
* Clone or download this repository
* Using the command line navigate in to the project folder and execute the command ```pip install -r requirements.txt``` this will install robot framework and the required supporting library's and their dependencies

Once everything has been installed you can run the test suite from the command line in the projects folder with the command```robot api.robot``` 

By default it will run on the live site on the web, this can be changed at the command line to point to a local instance of restfulbooker by running ```robot -v BASE_URL:127.0.0.1:80 api.robot``` or changing the ${BASEURL} variable in the api.robot file

#### RUN
```sh
robot -v ENV:local testcases/
```
#### Run Only Sanity Testing
```sh
robot -v ENV:local -i sanity testcases/
```

#### Docker Compose

```sh
docker-compose up -d
```
