# Do the generated values actually reach the container as environment?
resource "task" "randoms" {
  description     = "Check the generated values reached the container"
  success_message = "All five generator types produced usable values."

  config {
    target  = resource.container.app
    timeout = "30s"
  }

  condition "env_populated" {
    description = "All five generated values are present and well formed"

    check {
      script          = "scripts/task/randoms/check.sh"
      failure_message = "One of the generated values is missing or malformed - see the Shell tab"
    }
  }
}

# Where does `template` write? It takes no target, so this is the open question.
resource "task" "templated" {
  description     = "Find the file the template resource generated"
  success_message = "The template landed inside the container."

  config {
    target  = resource.container.app
    timeout = "30s"
  }

  condition "config_present" {
    description = "/tmp/generated/app.conf exists in the container and was rendered"

    check {
      script          = "scripts/task/templated/check.sh"
      failure_message = "The templated file is not in the container - template may not write into containers"
    }

    solve {
      script = "scripts/task/templated/solve.sh"
    }
  }
}
