resource "layout" "default" {
  column {
    width = "60"

    tab "shell" {
      title  = "Shell"
      target = resource.terminal.app
      active = true
    }

    tab "editor" {
      title  = "Editor"
      target = resource.editor.workspace
    }
  }

  column {
    width = "40"

    instructions {
      active = true
    }

    tab "values" {
      title  = "Values"
      target = resource.note.values
    }
  }
}
