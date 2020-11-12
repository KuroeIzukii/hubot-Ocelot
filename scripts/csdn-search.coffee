# Description:
#   Search on Baidu via Ocelot.
#
# Commands:
#   hubot csdn <query> - 在 CSDN 上搜索 <query>
cheerio = require('cheerio')

do_search = (msg, query) ->
  url = "https://so.csdn.net/so/search/s.do?q=#{query}"
  msg.robot.http(url).header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3100.0 Safari/537.36').header('Accept', 'application/json').get() (err, res, body) ->
    if res.statusCode isnt 200
      msg.send "查询时出现错误(Request didn't come back HTTP 200)"
      return
    else if err
      msg.send err
      return
    data = cheerio.load(body)
    a = data.html()
    console.log(a)

module.exports = (robot) ->
  robot.respond /(?:csdn) (.*)/i, (msg) ->
    query = msg.match[1]
    do_search(msg, query)