# kapi-html
 api接口调试工具,类似yapi,用户体验更佳,此为kapi前端代码,运行需要kpi后端支持.可以在github.com/xilin693找到kapi
后端项目地址
## 配置修改
```
    1. 开发环境调试vue.config.js中targetUrl为后端api地址,默认为kapi.local,请根据实际域名配置
    2. 远程运行环境需要在nginx中反向代理/api
         location /api {
            rewrite  ^/api/(.*)$ /$1 break;
            proxy_pass  http://xxx.com.cn/; // 此网址为kapi后端地址
        }
```
* 运行
```
yarn install
yarn run serve //  本地调试
yarn run dev-build // 远程部署
```
* 默认用户名密码
```
用户名: admin
密码: 123456a
```
* 管理员操作说明
  * 新用户通过kapi前台注册,管理员登录后,点用户名下拉"管理员设置"进入用户审核,可将新用户设置为"后端/前端/测试(其他)"
    * 后端用户访问接口时会自动进入接口的调试页面,前端用户会进入接口预览页面
  * 管理员可以创建项目组,所有项目都需要通过项目组创建
  * 员工离职后,管理员可以将该用户改为"审核不通过",用户将无法登录
* 普通用户操作
  * 登录系统后,点击添加项目(需要由管理员配置好项目组),创建完即为此项目管理员,可以拉其他员工进入该项目
  * 创建项目结束后,点击左侧列表的项目组可以看到创建好的项目,点击项目名称进入该项目
  * 配置接口需要先"添加分类",然后才能创建接口.
  * 接口可以设置环境变量,进入项目点左上角"设置"按钮进行创建,个人本地环境建议设置为"私有",这样其他人员就看不到此配置,不会影响到他人
    * 公共的环境不要设置为私有,以便所有人都能看到并进行调试
    * 环境变量设置为"默认",在接口列表该环境变量会排在第一位,此设置针对个人,不会影响同事的配置
    * 建议在环境变量中设置能用的header,这样就不需要每个接口都添加一次header.
  * 如果post不用使用form data,那么需要在"设置"->"项目设置"中勾选"允许post json",这样在添加post接口时通过下拉三角图标选择"post json"
    输入json值,适用于java spring项目,当然php项目使用也可以.这样前端开发java或php都可以统一
  * 每次添加或修改接口后记得点"保存全部"按钮
  * 在接口页面点"文档"可以对接口的各种参数作说明
  * 接口支持自动生成,点"设置",切换到"接口生成"的tab页,输入库名/表名/接口分类名/restful名称,生成接口
    * 生成接口依赖的是env的rest配置,需要给该配置的mysql用户更高的权限,才能访问到输入的库
    * 接口生成需要使用到mysql的表注释,所以创建表时,建议注释字段
    * "post json"复选框,表现生成的post代码,post默认内容为json,适用于java spring项目
    * 页面会显示出生成的内容,可直接在生成前修改,也可以生成后再进行修改