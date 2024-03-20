

resource "google_artifact_registry_repository" "lipingtababa" {
  repository_id      = "bullets" 
  description        = "A repository for Docker images"
  format             = "DOCKER"
}
