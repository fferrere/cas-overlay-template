Apereo CAS WAR Overlay Standalone - Accept http://localhost:5000
================================================================

WAR Overlay Type: `cas-overlay`

Forked from https://github.com/apereo/cas-overlay-template

# Changes from apereo version
- Only tested on linux
- Build docker image only
  - With json services properties to authorize http://localhost:5000 client
  - With self-signed certificate

# Versions

- CAS Server `7.0.0-SNAPSHOT`
- JDK `17`

# Build - Docker

## Dockerfile

```bash
chmod +x *.sh
sudo ./docker-build.sh
```

# Deployment

```bash
sudo docker run --rm -p 8443:8443 --name=cas apereo/cas:v7.0.0-SNAPSHOT
```

On a successful deployment, the server will be available at:


* `https://localhost:8443/cas`

