# wordpress-traefik-docker-swarm
This template project lets you deploy WordPress enviroment both in local or production. Utilizing Docker for container orchestration, then Traefek v1.7 for SSL (self-signed), load balancing, and reverse proxy.

## Usage

### Setup and configuration
Check the `.env` file and modify the values as needed.

### For local development
First step is to generate self-signed certificates. The easiest method is to use **`mkcert`** command. Check [instructions on how to install **`mkcert`**](https://github.com/FiloSottile/mkcert).
```
mkdir certs && cd $_ && mkcert docker.localhost "*.docker.localhost" && cd ..
```
There will be two `.pem` files generated. This will be used by traefik.

Alternatively, you can can use `openssl` command:
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt
```
However, this method requires extra step in order for the SSL to work properly in your browser. A well detailed instruction is provided [here](https://stackoverflow.com/questions/21488845/how-can-i-generate-a-self-signed-certificate-with-subjectaltname-using-openssl/21494483#21494483). 
Keep in mind, generating the certificates is a **one time process** only since website will be hosted in subdomain. However, you can opt to generate as many certificates as you want.

Run `traefik-compose.yml` first:
```
docker-compose -f traefik-compose.yml up -d
```
Modify `wordpress-compose.yml` configs especially the subdomain and then run:
```
docker-compose -f wordpress-compose.yml up
```

### For production enviroment
Run `traefik-stack.yml` first:
```
docker stack deploy --compose-file traefik-compose.yml  myapp
```
Check `config-production.yml` and uncomment line 33 if the site is still on staging. Uncomment line 38-40 if you want to opt for DNS challenge.
Modify  `wordpress-stack.yml` configs as needed and then run:
```
docker stack deploy --compose-file wordpress-stack.yml myapp
```
Keep in mind, for DNS challenge you need to add additional environment variable. More details and instruction, check [Traefik ACME (Let's Encrypt) Configuration](https://docs.traefik.io/v1.7/configuration/acme/).
