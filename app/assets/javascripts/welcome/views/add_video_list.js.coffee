WelcomeApp.Views.AddVideoList = Backbone.View.extend

  append: (video) ->
    subview = new WelcomeApp.Views.AddVideoItem
      model: video

    @$el.append subview.el
    subview.$el.fadeIn(300)
