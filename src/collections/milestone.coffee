class @MilestoneCollection extends Backbone.Collection
  
  initialize: (choosen_url) ->
    @choosen_url = choosen_url

  model: MilestoneModel
  url: -> ['https://api.github.com/repos',@choosen_url,"milestones"].join("/")
