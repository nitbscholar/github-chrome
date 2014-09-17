class @AssigneeCollection extends Backbone.Collection
  
  initialize: (choosen_url) ->
    @choosen_url = choosen_url

  model: AssigneeModel
  url: -> ['https://api.github.com/repos',@choosen_url,"assignees"].join("/")
