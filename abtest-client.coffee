class ABTest
  randomNumber = (min, max) -> Math.floor(Math.random() * (max - min + 1) + min )
  weightedRand = (spec) ->
    table = []
    for i of spec
      j = 0
      while j < spec[i]
        table.push i
        j++
    ->
      table[Math.floor(Math.random() * table.length)]

  cookies = null
  getCookie = (name) ->
    if not cookies
      cookies = {}
      for cookie in document.cookie.split('; ')
        pair = cookie.split('=')
        cookies[pair[0]] = pair[1]
    return cookies[name]

  setCookie = (name, value, days) ->
    if days
      date = new Date()
      date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
      expires = "; expires=" + date.toGMTString()
    else
      expires = ""
    document.cookie = name + "=" + value + expires + "; path=/"
    return

  getLocalStorage = (name) ->
    if localStorage
      localStorage.getItem(name)

  setLocalStorage = (name, value) ->
    if localStorage
      localStorage.setItem name, value
    getLocalStorage(name)

  getValue = (name) -> getLocalStorage(name) || getCookie(name) || Session.get(name)
  setValue = (name, value) -> setLocalStorage(name, value) || setCookie(name, value, 5000) || Session.set(name, value)

  removeValue = (name) ->
    localStorage.removeItem name if localStorage
    setCookie name, '', -1
    Session.set(name, undefined)

  storageName = (name) -> "abtest-#{name}"

  @start = (name, values) ->
    value = getValue storageName(name)
    if not value
      if values instanceof Array
        randomIndex = randomNumber(0, values.length - 1)
        value = values[randomIndex]
      else
        value = weightedRand(values)()
      setValue storageName(name), value
      Meteor.call 'startAbTest', name, value, randomIndex
    value

  @finish = (name) ->
    value = getValue storageName(name)
    if value
      Meteor.call 'finishAbTest', name, value
      removeValue name

  @reset = (name) -> Meteor.call 'resetAbTest', name