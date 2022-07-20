# DevSecOps Challenge

> DevSecOps Challenge


__Requirements__:
- Linux
- Docker
- Docker Compose


## Build Local Infra

__Make sure to run this image from a Linux environment__

```
git clone https://github.com/dszortyka/devsecops_challenge01.git
cd devsecops_challenge01/src/infra
docker-compose build
```

## Run Infra
```
docker-compose -f docker-compose.yml -f dependecytrack/docker-compose.yml up -d
```

## Generate SBOM Files
```
cd devsecops_challenge01/src/infra
chmod 755 generate_sbom_files.sh
./generate_sbom_files.sh
```

## Upload SBOM Files in the DependecyTrack Tool
* Open http://localhost:8080
* Login
* Create a project called "python" and another project "dotnet"
* Manually upload files from __devsecops_challenge01/sbom_files__
