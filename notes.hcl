# Notes tab, with Handlebars variables injected from the generators.
resource "note" "values" {
  file = "notes/values.md"

  variables = {
    app_name = variable.app_name
    codename = resource.random_creature.codename.value
    build_id = resource.random_id.build.hex
    replicas = resource.random_number.replicas.value
  }
}
