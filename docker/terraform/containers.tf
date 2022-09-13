resource "docker_container" "nginx" {
  name  = "mabaya_nginx"
  image = docker_image.nginx.image_id

  ports {
    external = 8000
    internal = 80
  }

  depends_on = [
    docker_container.echo_service_1,
    docker_container.echo_service_2,
    docker_image.echo_service
  ]
}

resource "docker_container" "mariadb" {
  name  = "mabaya_mariadb"
  image = docker_image.mariadb.image_id

  ports {
    external = 3306
    internal = 3306
  }

  depends_on = [
    docker_image.mariadb
  ]
}

resource "docker_container" "prometheus" {
  name  = "mabaya_prometheus"
  image = "prom/prometheus:main"

  ports {
    external = 9090
    internal = 9090
  }

  volumes {
    host_path      = "${abspath(path.root)}/../../prometheus/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }
}

resource "docker_container" "grafana" {
  name  = "mabaya_grafana"
  image = "grafana/grafana:6.2.5"

  ports {
    external = 3000
    internal = 3000
  }

  volumes {
    host_path      = "${abspath(path.root)}/../../grafana/datasource.yml"
    container_path = "/etc/grafana/provisioning/datasources/prometheus.yml"
  }

  volumes {
    host_path      = "${abspath(path.root)}/../../grafana/dashboard-providers.yml"
    container_path = "/etc/grafana/provisioning/dashboards/dashboard-providers.yml"
  }

  volumes {
    host_path      = "${abspath(path.root)}/../../grafana/dashboards/"
    container_path = "/var/lib/grafana/dashboards/"
  }
}

resource "docker_container" "echo_service_1" {
  name  = "mabaya_echo_service_1"
  image = docker_image.echo_service.image_id

  ports {
    external = 8001
    internal = 8000
  }

  volumes {
    host_path      = "${abspath(path.root)}/../../logs/example.log"
    container_path = "/usr/bin/src/webapp/src/example.log"
  }
}

resource "docker_container" "echo_service_2" {
  name  = "mabaya_echo_service_2"
  image = docker_image.echo_service.image_id

  ports {
    external = 8002
    internal = 8000
  }

  volumes {
    host_path      = "${abspath(path.root)}/../../logs/example.log"
    container_path = "/usr/bin/src/webapp/src/example.log"
  }
}
