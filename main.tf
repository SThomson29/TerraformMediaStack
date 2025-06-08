resource "docker_network" "private_network" {
  name = "network_stack"
  driver = "bridge"
}

data "docker_registry_image" "swag" {
  name = "ghcr.io/linuxserver/swag:latest
}

resource "docker_image" "swag" {
  name         = data.docker_registry_image.swag.name
  pull_triggers = [data.docker_registry_image.swag.sha256_digest]
}

resource "docker_container" "swag" {
  name  = "swag"
  image = docker_image.swag.image_id

  restart = "always"

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  volumes {
    host_path      = "/home/user/dir/Swag/config"
    container_path = "/config"
  }

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=GB",
    "URL=${var.my_domain}",
    "VALIDATION=dns",
    "DNSPLUGIN=cloudflare",
    "SUBDOMAINS=wildcard",
    "PROPAGATION=60",
    "STAGING=false",
    "SWAG_AUTORELOAD=true",
    "DISABLE_F2B=true",
  ]
  network_mode = "network_stack"
}

data "docker_registry_image" "plex" {
  name = "ghcr.io/linuxserver/plex:latest
} 

resource "docker_image" "plex" {
  name         = data.docker_registry_image.plex.name
  pull_triggers = [data.docker_registry_image.plex.sha256_digest]
}

resource "docker_container" "plex" {
  name  = "plex"
  image = docker_image.plex.image_id

  restart = "always"

  env = [
    "PUID=1000",
    "PGID=1000",
    "VERSION=docker",
    "PLEX_CLAIM=${var.plex_claim}",
    "REGION=United Kingdom",
    "TZ=GB",
  ]

  volumes {
    host_path      = "/home/user/dir/Plex/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/home/user/dir/Downloads/TV"
    container_path = "/tv"
  }

  volumes {
    host_path      = "/home/user/dir/Downloads/Movies"
    container_path = "/movies"
  }
  network_mode = "host"
}

data "docker_registry_image" "prowlarr" {
  name = "ghcr.io/linuxserver/prowlarr:latest
}

resource "docker_image" "prowlarr" {
  name         = data.docker_registry_image.prowlarr.name
  pull_triggers = [data.docker_registry_image.prowlarr.sha256_digest]
}

resource "docker_container" "prowlarr" {
  name  = "prowlarr"
  image = docker_image.prowlarr.image_id

  restart = "always"

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=GB",
  ]

  volumes {
    host_path      = "/home/user/dir/Prowlarr/config"
    container_path = "/config"
  }
  network_mode = "network_stack"
}

data "docker_registry_image" "radarr" {
  name = "ghcr.io/linuxserver/radarr:latest
}

resource "docker_image" "radarr" {
  name         = data.docker_registry_image.radarr.name
  pull_triggers = [data.docker_registry_image.radarr.sha256_digest]
}

resource "docker_container" "radarr" {
  name  = "radarr"
  image = docker_image.radarr.image_id

  restart = "always"

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=GB",
  ]

  volumes {
    host_path      = "/home/user/dir/Radarr/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/home/user/dir/Media/Downloads"
    container_path = "/downloads"
  }
  network_mode = "network_stack"
}

data "docker_registry_image" "sonarr" {
  name = "ghcr.io/linuxserver/sonarr:latest
}

resource "docker_image" "sonarr" {
  name         = data.docker_registry_image.sonarr.name
  pull_triggers = [data.docker_registry_image.sonarr.sha256_digest]
}

resource "docker_container" "sonarr" {
  name  = "sonarr"
  image = docker_image.sonarr.image_id

  restart = "always"

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=GB",
  ]

  volumes {
    host_path      = "/home/user/dir/Sonarr/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/home/user/dir/Media/Downloads"
    container_path = "/downloads"
  }
  network_mode = "network_stack"
}

data "docker_registry_image" "sabnzbd" {
  name = "ghcr.io/linuxserver/sabnzbd:latest
}

resource "docker_image" "sabnzbd" {
  name         = data.docker_registry_image.sabnzbd.name
  pull_triggers = [data.docker_registry_image.sabnzbd.sha256_digest]
}

resource "docker_container" "sabnzbd" {
  name  = "sabnzbd"
  image = docker_image.sabnzbd.image_id

  restart = "always"

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=GB",
  ]

  volumes {
    host_path      = "/home/user/dir/Sabnzbd/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/home/user/dir/Media/Downloads"
    container_path = "/downloads"
  }
  network_mode = "network_stack"
}

data "docker_registry_image" "gravity" {
  name = "ghcr.io/beryju/gravity:latest
}

resource "docker_image" "gravity" {
  name         = data.docker_registry_image.gravity.name
  pull_triggers = [data.docker_registry_image.gravity.sha256_digest]
}

resource "docker_container" "gravity" {
  name  = "gravity"
  image = docker_image.gravity.image_id

  restart = "always"

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=GB",
  ]

  user = "root"
  
  volumes {
    host_path      = "/home/user/dir/Gravity/config"
    container_path = "/data"
  }
  
  network_mode = "host"

  log_driver = "json-file"

  log_opts = {
    max-size = "10m"
    max-file = "3"
  }
}

data "docker_registry_image" "lidarr" {
  name = "ghcr.io/linuxserver/lidarr:latest
}

resource "docker_image" "lidarr" {
  name         = data.docker_registry_image.lidarr.name
  pull_triggers = [data.docker_registry_image.lidarr.sha256_digest]
}

resource "docker_container" "lidarr" {
  name  = "lidarr"
  image = docker_image.lidarr.image_id

  restart = "always"

  env = [
    "PUID=1000",
    "PGID=1000",
    "TZ=GB",
  ]

  volumes {
    host_path      = "/home/user/dir/Lidarr/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/home/user/dir/Media/Downloads"
    container_path = "/downloads"
  }
  network_mode = "network_stack"
}


