resource "terminal" "app" {
  target = resource.container.app
  shell  = "/bin/sh"
}

# NOTE: `editor` takes neither `target` nor `directory` at the top level - both
# belong inside a `workspace` block. `instruqt lab validate` accepts the wrong
# form and reports SUCCESS; the platform rejects it at play time with
# "An argument named \"target\" is not expected here". See FINDINGS.md (V1).
resource "editor" "workspace" {
  # Inside the container.
  workspace "container" {
    target    = resource.container.app
    directory = "/tmp"
  }

  # Omitting `target` reads the local filesystem - a second way to find out
  # where `template` actually wrote its output.
  workspace "local" {
    directory = "/tmp/generated"
  }
}
