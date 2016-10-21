----
title: 使用webhook实现hexo文章自动发布
----

#### notice
本指南是在基于读者本身对hexo博客系统的部署、服务器配置、http协议以及linux shell等相关技术有一定的基础之上的

#### webhook是什么
貌似这是第一次写技术指南之类的（其实感觉谈不上，更多的意义算是科普吧）
webhook 顾名思义其实就是个钩子，当我们对 github 上的某个仓库设置了 webhook 之后，当我们 push (默认的)一个新的 commit 的时候，github 将向我们设置的服务器推送一条带 payload 的信息。
如下图所示，payload 中我们将可以获得仓库的各种信息。

![webhook](https://ws2.sinaimg.cn/large/005ZGW1Jjw1f74v0bg5hkj315a12itg3.jpg)

这种时候我们其实只需要在我们自己的服务器上搭建一个自己的服务来接收这个请求，并相应的做某些事就好了

#### 服务器端配置
首先你要对写服务端有一些经验，这里以 nodejs 为例

```
const http = require('http')
const child_process = require('child_process')
const createHandler = require('github-webhook-handler')
const handler = createHandler({ path: '/deploy/', secret: 'your secret' })
const PORT = 9988

http.createServer((req, res) => {
  handler(req, res, err => {
    console.log(err)
    res.statusCode = 404
    res.end('no such location')
  })
}).listen(9988)

handler.on('push', event => {
  let commands = ['cd ../posts', 'git pull', 'make deploy'].join('&&');
  child_process.exec(commands, (err, stdout, stderr) => {
    process.stderr.write(stderr)
    process.stdout.write(stdout)
  });
})
```
1. 我们新建了一个http服务并监听了服务器的9988端口
2. 我们使用 [github-webhook-handler](https://www.npmjs.com/package/github-webhook-handler) 来对请求进行处理
3. 当 github 对服务器的 deploy 这个 path 发出请求时，handler 将对请求中包含的事件进行检测，如果是 push 事件的话则利用 [child_process](https://nodejs.org/api/child_process.html) 执行以下命令 `cd ../posts` `git pull` `make deploy`, 依次是进入文章所在目录，拉取最新的代码，最后 执行make deploy 进行发布
4. 具体各个模块api 的使用方法请自行 google 在此不在一一列出
5. 要注意的事，如果用 [github-webhook-handler](https://www.npmjs.com/package/github-webhook-handler) 则要求 sercret 必填，随意设置一下就好
6. 在启动服务时，如果端口已被占用的话会报错，需要注意一下
7. 一般来说，当你手动启动一个node服务的时退出ssh的话，这个服务会自动关闭，如果需要持久话运行的话 可以使用 [forever](https://www.npmjs.com/package/forever) ，可以使用 `npm install forever -g` 来安装，具体使用方法自行看文档就好

#### makefile

```
postPath := ../workSpace/source/_posts
deploy:
        @if [ -d "$(postPath)" ]; then rm -rd $(postPath); fi
        @mkdir -p $(postPath)
        @cp -f *.md $(postPath)
        @rm $(postPath)/README.md
        @cd ../workSpace; hexo deploy -g
```

当然对应目录请做相应修改 👻
最后: 本人只是个技术渣渣，本文只是一篇简单指南而已，不足之处请多多指教，喷请轻喷
