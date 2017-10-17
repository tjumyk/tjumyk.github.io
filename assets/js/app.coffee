angular.module 'app', []

.controller 'HomeController', ['$scope', '$http', 'util', ($scope, $http, util)->
  $body = $('html, body')
  $app_menu = $('.app.menu')
  $repos = $('.repo-groups')
  $articles = $('.articles.segment')
  $site_title = $('.site.header')
  $meow_sound = $('.meow-sound')

  $animate_logo = $('.animate-logo')
  $left_eye = $animate_logo.find('img.left.eye')
  $right_eye = $animate_logo.find('img.right.eye')

  github_user_name = $("meta[name='github-username']").attr('content')

  $scope.show_full_repo_list = false

  $scope.goTo = (target)->
    scroll_to = undefined
    if target == 'repos'
      scroll_to = $repos
    else if target == 'articles'
      scroll_to = $articles
    if scroll_to
      $body.animate
        scrollTop: scroll_to.offset().top - $app_menu.height()
      , 500
    return

  $scope.date_to_now = (date)->
    return moment(date).toNow()

  init_animate_logo = ->
    left_eye_anchor = [.429, .497]
    left_eye_init_offset = [.003, .014]
    left_eye_move_range = [.023, .023]
    right_eye_anchor = [.665, .495]
    right_eye_init_offset = [0, .015]
    right_eye_move_range = [.02, .02]

    $(document).on 'mousemove', (e)->
      base_offset = $animate_logo.offset()
      width = $animate_logo.width()
      height = $animate_logo.height()
      if $body.scrollTop() >= base_offset.top + height - $app_menu.height() # logo not visible
        return
      x = e.pageX
      y = e.pageY

      left_eye_angle = Math.atan2(y - (left_eye_anchor[1] * height + base_offset.top), x - (left_eye_anchor[0] * width + base_offset.left))
      left_eye_move_x = (left_eye_move_range[0] * Math.cos(left_eye_angle) - left_eye_init_offset[0]) * width
      left_eye_move_y = (left_eye_move_range[1] * Math.sin(left_eye_angle) - left_eye_init_offset[1]) * height

      right_eye_angle = Math.atan2(y - (right_eye_anchor[1] * height + base_offset.top), x - (right_eye_anchor[0] * width + base_offset.left))
      right_eye_move_x = (right_eye_move_range[0] * Math.cos(right_eye_angle) - right_eye_init_offset[0]) * width
      right_eye_move_y = (right_eye_move_range[1] * Math.sin(right_eye_angle) - right_eye_init_offset[1]) * height

      $left_eye.css
        transform: "translate(#{left_eye_move_x}px, #{left_eye_move_y}px)"
      $right_eye.css
        transform: "translate(#{right_eye_move_x}px, #{right_eye_move_y}px)"

  init_site_title = ->
    text = $site_title.text()
    $site_title.attr('aria-label', text).empty()
    for ch in text.split('')
      span = $("<span class='char' aria-hidden='true'>#{ch}</span>")
      $site_title.append(span)
      if ch == '喵' and $meow_sound.length
        span.on 'mouseenter', ->
          $meow_sound[0].play()


  init_lazyload = ->
    lazyload_config =
      load: ->
        $this = $(@)
        $this.removeClass('lazy').addClass($this.data('loaded-class'))
    $(".repo-groups img.lazy").lazyload(lazyload_config)
    $(".articles.segment img.lazy").lazyload(lazyload_config)

  request_github_api = ->
    $http.get("https://api.github.com/users/#{github_user_name}/repos").then (response)->
      repos = {}
      for repo in response.data
        repos[repo.name] = repo
      $scope.repos = repos
    , (response)->
      console.error(util.formatResponseError(response))

  init_animate_logo()
  init_site_title()
  init_lazyload()
  request_github_api()
]