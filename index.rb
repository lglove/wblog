#encoding: utf-8

require "webrick"

TOKEN = "testapi"

class WeixinServer < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    p 'GET %s' % request.path

    timestamp = request.query["timestamp"]
    nonce = request.query["nonce"]
    if timestamp && nonce
      #1.将token，timestamp，nonce三个参数进行字典序排序
      sort_str = [TOKEN, timestamp, nonce].sort.join
      #2.将三个参数字符串进行sha1加密
      digest = Digest::SHA1.hexdigest sort_str
      #3.开发者获得加密后的字符串于signature对比，表示该请求来源于微信
      if digest == request.query["signature"]
        #4.确认此次GET请求来自于微信服务器，原样返回echostr参数内容
        response.status = 200
        response.content_type = "text/plain"
        response.body = request.query["echostr"]
      else
        response.status = 400
        response.body = "Signature is incorrect!"
      end

    else
      response.status = 200
      response.body = "Parameters is incorrect!"
    end
  end
end

server = WEBrick::HTTPServer.new(:Port => 5454)

server.mount "/", WeixinServer

trap("INT") {
  server.shutdown
}

server.start
