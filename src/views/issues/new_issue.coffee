class @NewIssueView extends Backbone.View

  className: 'new-issue'

  events:
    "submit form" : "onSubmit"
    "click .repos" : "onRepoChange"

  initialize: (@options) ->
    @myopt = @options
    @repositories = @options.repositories

  render: ->
    @$el.html(HAML['new_issue'](repositories: @repositories))
    @$('select').select2()
    @$('.assignee,.milestone').select2(
      data : 
        id: -1
        text: ''
    )
    @onRepoChange()
    @

  onRepoChange: (e) ->
    name = @$("[name=repository]").val()
    
    # setting the assignees
    assignee = new AssigneeCollection(name)
    milestone = new MilestoneCollection(name)
		
    assignee.fetch
      reset: true
      success: (assignee) =>
        
        selectors = 
          data: []
        selectors.data.push(
          id: user.get('login')
          text: user.get('login')
        ) for user in assignee.models
		
        @$(".assignee").select2(selectors)

      
      error: =>
        @$('.assignee').select2(
          data : 
            id: -1
            text: ''
        )

    
    milestone.fetch
      reset: true
      success: (milestone) =>
        
        selectors = 
          data: []
        selectors.data.push(
          id: user.get('number')
          text: user.get('title')
        ) for user in milestone.models
		
        @$(".milestone").select2(selectors)

      
      error: =>
        @$('.milestone').select2(
          data : 
            id: -1
            text: ''
        )

      
  onSubmit: (e) ->
    e.preventDefault()
    name = @$("[name=repository]").val()
    localStorage['new_issue_last_repo'] = name
    repository = @repositories.find (r) -> r.get('full_name') == name
    
    doc = 
      body: @$("[name=body]").val()
      title: @$("[name=title]").val()
      assignee: @$(".assignee").select2('data').id
      milestone: @$(".milestone").select2('data').id

    
    model = new IssueModel(doc, {repository: repository})
    model.save {},
      success: (model) =>
        @badge = new Badge()
        @badge.addIssues(1)
        @$('.message').html("<span>Issue <a href=\"#{model.get("html_url")}\" target=\"_blank\">##{model.get('number')}</a> was created!</span>")
      error: =>
        @$('.message').html("<span>Failed to create issue :(</span>")

