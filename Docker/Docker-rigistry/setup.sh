tee docker-compose.yml << EOF
version: '2.0'
services:
  registry:
    image: registry:2
    volumes:
      - ./registry-data:/var/lib/registry
    ports:
      - "5000:5000"
    networks:
      - registry-ui-net

  ui:
    image: joxit/docker-registry-ui:static
    ports:
      - 8080:80
    environment:
      - REGISTRY_TITLE=My Private Docker Registry
      - REGISTRY_URL=http://registry:5000
      - DELETE_IMAGES=true
    depends_on:
      - registry
    networks:
      - registry-ui-net

networks:
  registry-ui-net:
EOF