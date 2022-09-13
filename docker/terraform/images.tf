resource "docker_image" "nginx" {
  name = "nginx:stable"
  build {
    path       = "../../nginx"
    dockerfile = "Dockerfile"
    tag        = ["nginx:stable"]
  }
}

resource "docker_image" "mariadb" {
  name = "mariadb:stable"
  build {
    path       = "../../mariadb"
    dockerfile = "Dockerfile"
    tag        = ["mariadb:stable"]
  }
}

resource "docker_image" "echo_service" {
  name = "echo-service"
  build {
    path       = "../../echo-service"
    dockerfile = "Dockerfile"
    tag        = ["echo-service:latest"]
  }
}
