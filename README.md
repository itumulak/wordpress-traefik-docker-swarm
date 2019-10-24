# wordpress-traefik-docker-swarm
This template project lets you deploy WordPress enviroment both in local and production. Utilizing Docker for container orchestration, then Traefik v1.7 for SSL (self-signed), load balancing, and reverse proxy.

## Usage

### Setup and configuration
Check the `.env` file and modify the values as needed.

#### For local development
First step is to generate self-signed certificates. The easiest method is to use **`mkcert`** command. Check [instructions on how to install **`mkcert`**](https://github.com/FiloSottile/mkcert#installation).
```
mkdir certs && cd $_ && mkcert docker.localhost "*.docker.localhost" && cd ..
```
There will be two `.pem` files generated stored in `certs` folder. This will be used by traefik later on.

Alternatively, you can can use `openssl` command:
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt
```
However, this method requires extra step in order for the SSL to work properly in your browser. A well detailed instruction is provided [here](https://stackoverflow.com/questions/21488845/how-can-i-generate-a-self-signed-certificate-with-subjectaltname-using-openssl/21494483#21494483).

Keep in mind, generating the certificates is a **one time process only** since website will be hosted in subdomain. Depending on your needs and structure, you can still opt to generate as many certificates as you want, just replace the default domain (docker.localhost) in `docker-compose.yml` and `config-staging.toml`. Replace the new 2 named `.pem` files in the `config-staging.toml` as well.

You would then need to create a network beforehand:
```
docker network create wp-traefik-local
```

Run `traefik-compose.yml` first:
```
docker-compose -f traefik-compose.yml up -d
```
Check by visting *https://traefik.docker.localhost/dashboard/*.

Next is to modify any configuratioin in `wordpress-compose.yml` and then run:
```
docker-compose -f wordpress-compose.yml up
```

For creating a new wordpress instance, simply copy `wordpress-compose.yml` and `.env`.
```
mkdir new-wp-project && \
cd $_  && \
cp ../wordpress-traefik-docker-swarm/wordpress-compose.yml . && \
cp ../wordpress-traefik-docker-swarm/.env .
```

**Having problems?** 
- Make sure the database service name is unique.
- Subdomain name is unique.
- The network is the same for every new wordpress instance.

#### For production enviroment
Check `config-production.toml`, supply your email on line 28 and uncomment line 33 if the site is still on staging. Getting or renewing ACME certificates is done through HTTP Challenge. Uncomment line 38-40 if you want to opt for DNS challenge.

Keep in mind, for DNS challenge, you need to add additional environment variable. For more details and instruction, check [Traefik ACME (Let's Encrypt) Configuration](https://docs.traefik.io/v1.7/configuration/acme/#dnschallenge).

Run `traefik-stack.yml` first:
```
docker stack deploy --compose-file traefik-compose.yml  myapp
```
Modify  `wordpress-stack.yml` configs as needed and then run:
```
docker stack deploy --compose-file wordpress-stack.yml myapp
```

On hindsight, the seperation of Traefik container from the WordPress stack is because we don't want it to go offline if you are updating the stack in the future to come. 
