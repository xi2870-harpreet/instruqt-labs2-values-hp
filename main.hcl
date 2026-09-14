resource "page" "values" {
  title = "Generated values"
  file  = "instructions/01-values.md"

  activities = {
    randoms = resource.task.randoms
  }
}

resource "page" "template" {
  title = "Where does a template land?"
  file  = "instructions/02-template.md"

  activities = {
    templated = resource.task.templated
  }
}

resource "lab" "main" {
  title       = "Dynamic values, generators and templates"
  description = "Probes the Early Access value plumbing: variables, all five random generators, template rendering, note variables, and an editor tab."

  settings {
    timelimit {
      duration   = "1h"
      show_timer = true
    }
  }

  layout = resource.layout.default

  content {
    chapter "values" {
      title = "Values"

      page "values" {
        reference = resource.page.values
      }

      page "template" {
        reference = resource.page.template
      }
    }
  }
}
