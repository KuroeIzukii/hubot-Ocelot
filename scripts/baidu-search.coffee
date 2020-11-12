# Description:
#   Search on Baidu via Ocelot.
#
# Commands:
#   hubot baidu|bd <query> - 在 百度 上搜索 <query>
cheerio = require('cheerio')

do_search = (msg, query) ->
  url = "https://www.baidu.com/s?ie=utf-8&wd=#{query}&pn=0&oq=#{query}"
  msg.robot.http(url).header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36').header('Accept', 'application/json').get() (err, res, body) ->
    if res.statusCode isnt 200
      msg.send "查询时出现错误(Request didn't come back HTTP 200)"
      return
    else if err
      msg.send err
      return
    data = cheerio.load(body)
    a = data('h3.t','div.result').html()
    if a == null
      msg.send "无搜索结果"
      return
    msg.send "*在 百度 上搜索 \"#{query}\" 的前三个结果:*"
    msg.send ""
    for num in [1..3]
      do (num) ->
        a = data('h3.t','div[id="' + num + '"]').html()
        res = cheerio.load(a)
        link = res('a').attr('href')
        title = res('a').text().replace /^\s+|\s+$/g, ""
        directlink = msg.robot.http(link).header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36').get() (err, res, body) ->
          for url in res.rawHeaders
            if url.search(/http(s)?:/) != -1
              msg.send("*#{title}*")
              msg.send(url)
              msg.send("")
      #await return

module.exports = (robot) ->
  robot.respond /(?:baidu|bd) (.*)/i, (msg) ->
    query = msg.match[1]
    do_search(msg, query)