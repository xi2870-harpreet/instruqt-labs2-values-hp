resource "terminal" "app" {
  target = resource.container.app
  shell  = "/bin/sh"
}

resource "editor" "workspace" {
  target    = resource.container.app
  directory = "/tmp"
}
