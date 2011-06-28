$ ->
  window.Task = Backbone.Model.extend
    url: ->
      if this.id? then 'tasks/' + this.id else '/tasks'

  window.TaskCollection = Backbone.Collection.extend
    model: Task
    url: ->
      'tasks'

  window.Tasks = new TaskCollection()

  window.TaskView = Backbone.View.extend
    tagName: 'tr'

    events:
      'click .delete': 'deleteTask'

    deleteTask: ->
      this.model.destroy()
      $(this.el).hide()

    render: ->
      source = $('#task_template').html()
      template = Handlebars.compile(source)
      task = this.model.toJSON()
      $(this.el).html(template(task))
      this

  window.TaskApp = Backbone.View.extend
    el: $('#tasks_app')

    events:
      'submit form': 'createTask'

    createTask: (e) ->
      e.preventDefault()
      name = $(e.currentTarget).find('#task_name').val()
      Tasks.create({name: name})

    initialize: ->
      _.bindAll(this, 'addAll', 'addTask')
      Tasks.bind('add', this.addTask)
      Tasks.bind('refresh', this.addAll)

      Tasks.fetch()


    addTask: (task) ->
      # alert('added')
      view = new TaskView({model: task})
      $('table#tasks').append(view.render().el)

    addAll: ->
      Tasks.each(this.addTask)

  window.app = new TaskApp()

