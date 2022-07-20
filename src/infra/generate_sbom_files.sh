#!/bin/bash

mkdir -p ../../sbom_files

docker exec infra_base_image /bin/bash -c "rm -f /app_python/syft.python.sbom.json"
docker exec infra_base_image /bin/bash -c "rm -f /app_python/cyclone.python.sbom.json"
docker exec infra_base_image /bin/bash -c "rm -f /app_dotnet/syft.dotnet.sbom.json"
docker exec infra_base_image /bin/bash -c "rm -f /app_dotnet/cyclone.dotnet.sbom.json"

docker exec infra_base_image /bin/bash -c "cd /app_dotnet/ProjectsRuler && dotnet CycloneDX ProjectsRuler.sln -o /app_dotnet/ -j"
docker exec infra_base_image /bin/bash -c "mv /app_dotnet/bom.json /app_dotnet/cyclone.dotnet.sbom.json"
docker exec infra_base_image /bin/bash -c "cd /app_python/diagrams && cyclonedx-bom -p --format=json -o /app_python/cyclone.python.sbom.json"
docker exec infra_base_image /bin/bash -c "cd /app_python && syft packages diagrams/ -o cyclonedx-json > /app_python/syft.python.sbom.json"
docker exec infra_base_image /bin/bash -c "cd /app_dotnet && syft packages ProjectsRuler/ -o cyclonedx-json > /app_dotnet/syft.dotnet.sbom.json"

docker exec infra_base_image /bin/bash -c "ls /app_dotnet"
docker exec infra_base_image /bin/bash -c "ls /app_python"


docker cp infra_base_image:/app_python/syft.python.sbom.json ../../sbom_files
docker cp infra_base_image:/app_python/cyclone.python.sbom.json ../../sbom_files
docker cp infra_base_image:/app_dotnet/syft.dotnet.sbom.json ../../sbom_files
docker cp infra_base_image:/app_dotnet/cyclone.dotnet.sbom.json ../../sbom_files