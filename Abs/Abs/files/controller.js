define("views/index",["images/style.css"],function(e,t,i){{var s=e("$"),o=e("util"),r=e("activity"),a=e("../widget/loading"),n=e("../widget/slider"),l=e("../core/model"),c=e("../widget/scroll");e("animation")}return r.extend({events:{tap:function(e){e.target==this.el&&this.back("/")},"tap .head_menu":function(e){this.forward("/menu")},"tap .js_comment_list [data-id]":function(e){var t=s(e.currentTarget);this.forward((1==t.data("type")?"/activity/":"/destination/")+t.data("id"))},"tap .js_comment":function(e){this.forward(this.user?"/comment":"/login")},"tap .footer li":function(e){var t=s(e.currentTarget);if(!t.hasClass("curr")){var i=t.index();t.addClass("curr").siblings(".curr").removeClass("curr"),this.$main.eq(i).show().siblings(".main").hide(),this.model.set("title",this.titles[i]),this.$el.find(".js_comment").css({display:3==i?"block":"none"}),this.loading[i].isDataLoaded||this.loading[i].load()}},"tap .quanli_reply":function(e){var t=s(e.currentTarget),i=t.closest("[data-id]"),r=i.data("id");o.store("replyAt","@"+i.data("at")),this.forward("/reply/"+r)}},swipeRightForwardAction:"/menu",className:"home",titles:["福州","目的地","活动","驴友圈"],onCreate:function(){var e=this;this.model=new l.ViewModel(this.$el,{menu:"head_menu",titleClass:"head_title",title:"福州"});var t=this.$main=this.$(".main");c.bind(t,{refresh:function(t,i){var s=this.parentNode.getAttribute("data-index");1==s?t():e.loading[s].reload({showLoading:!1},function(e,s){e?i(e):t(s)})}}),this.loading=[],["/api/activity/recommend","/api/destination/list?getall=1","/api/activity/list","/api/quan/list"].forEach(function(i,s){var o=new a({url:i,$el:t.eq(s),$content:t.eq(s).children(":first-child"),$scroll:t.eq(s),success:function(t){this.isDataLoaded=!0,1==s?e.slider=new n(this.$content,{arrow:!0,itemTemplate:'<a href="/destination/<%=ID%>" forward><img src="<%=LargePic%>"></a>',data:t.data}):e.model.set("data"+s,t.data)},append:function(t){e.model.get("data"+s).append(t.data)}});e.loading.push(o)}),this.loading[0].load(),e.onResult("comment_success",function(){e.loading[3].reload()})},onShow:function(){var e=this;e.user=o.store("user")},onDestory:function(){}})});define("template/menu",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<div class="menu_bd"> <div class="menu_user" sn-binding="data-back:memberUrl"> <img class="menu_avatars" sn-binding="src:user.Avatars" /> <div class="menu_username"> <h1 sn-binding="html:user|equal:null:\'未登录\':user.NickName"></h1> <h2 sn-binding="html:user.Mobile"></h2> </div> </div> <ul class="menu_list"> <li class="menu_activity" data-back="/myactivity">我的活动</li> <li class="menu_comments" data-back="/mycomments">我的评论</li> </ul> <ul class="menu_list"> <li class="menu_pwd" data-back="/modifypwd">修改密码</li> <li class="menu_settings" data-back="/member">设置</li> <li class="menu_logout" sn-binding="display:user" sn-on="click:logout">退出</li> </ul> </div>';return __},helpers:{}});return T.template=T.html,T});define("template/about",function(require){var util=require("util"),T={html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main"> <div class="aboutus"> 邻师是一个针对0～18岁学生（家长）和教师的教育资源整合平台，我们专门帮助小微培训机构，教师工作室及教师个人进行品牌塑造和市场推广，我们希望让老师能够招到更多的优质学生，让学生找到更合适自己的老师。 <img src="'+util.encodeHTML(webresource("images/aboutus.jpg"))+'" /> <div class="aboutus_ver">发现身边好老师</div> </div> </div> ';return __},helpers:{}};return T.template=T.html,T});define("views/menu",["images/style.css"],function(e,t,i){{var a=(e("$"),e("util")),n=e("activity"),r=e("bridge"),l=e("core/model");e("../widget/scroll"),e("../widget/loading")}return n.extend({toggleAnim:"menu",className:"menu",events:{tap:function(e){},"tap [data-logout]":function(e){}},swipeLeftBackAction:"/",onCreate:function(){var e=this;r.hasStatusBar&&this.$el.find(".fix_statusbar").addClass("fix_statusbar"),this.model=new l.ViewModel(this.$el,{memberUrl:"/member",logout:function(){a.store("user",null),e.back("/")}})},onShow:function(){var e=this,t=a.store("user");t?e.isLoad||(e.isLoad=!0,e.user=t,e.model.set({user:t})):this.model.set({user:null})},onDestory:function(){}})});define("template/member",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main scrollview"> <div class="member"> <iframe style="top:-999px;left:-999px;position:absolute;display:none;" frameborder="0" width="0" height="0" name="__upload"></iframe> <form sn-binding="action:upload" method="post" class="member_avatars" enctype="multipart/form-data"> <input type="file" name="Avatars" /> <input type="hidden" name="userId" sn-binding="value:user.ID" /> <input type="hidden" name="auth" sn-binding="value:user.Auth" /> <img sn-binding="src:user.Avatars" /> </form> <ul class="member_info"> <li> <div>昵称</div> <div><input sn-binding="value:user.NickName,readonly:NickName.readonly" sn-model="NickName.input" /></div> <b sn-binding="class:NickName.edit,html:NickName.value" sn-on="tap:NickName.click"></b> </li> <li class="member_one"> <div>性别：</div> <div> <span class="radio" member="gender" value="1" sn-binding="class:user.Gender|equal:1:\'checked radio\':\'radio\'">男</span> <span class="radio" member="gender" value="0" sn-binding="class:user.Gender|equal:0:\'checked radio\':\'radio\'">女</span> </div> </li> <li> <div>地址</div> <div><input sn-binding="value:user.Address,readonly:Address.readonly" sn-model="Address.input" /></div> <b sn-binding="class:Address.edit,html:Address.value" sn-on="tap:Address.click"></b> </li> </ul> </div> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/member",["images/style.css"],function(e,t,i){var a=e("$"),n=(e("util"),e("activity")),r=e("core/model"),d=(e("../widget/scroll"),e("bridge")),o=e("../widget/loading"),c=0;return n.extend({events:{'tap [member="gender"]':function(e){var t=e.currentTarget.getAttribute("value");this.model.get("user.Gender")!=t&&this.setMemberInfo({userid:this.user.ID,auth:this.user.Auth,Gender:t})},'change form input[type="file"]':function(e){c++;{var n,t=this,i=e.target.parentNode,s="_submit_iframe"+c;a('<iframe style="top:-999px;left:-999px;position:absolute;display:none;" frameborder="0" width="0" height="0" name="'+s+'"></iframe>').appendTo(document.body).on("load",function(){var e;try{e=a.trim(this.contentWindow.document.body.innerHTML)}catch(i){return void t.loading.load()}if(!n||e!=n){n=e;try{if(e=JSON.parse(n),e.success){var s=Date.now();localStorage.setItem("photo_ver",s),t.loading.load()}else sl.tip(e.msg)}catch(i){sl.tip(i.message)}}})}i.target=s,i.submit()}},swipeRightBackAction:"/",setMemberInfo:function(e){var t=this;this.loading.showLoading(),a.post(d.url("/api/user/update"),e,function(i){i.success?t.model.set("user",e):sl.tip(i.msg),t.loading.hideLoading()},"json")},onCreate:function(){var e=this;this.model=new r.ViewModel(this.$el,{title:"个人信息",back:"/",upload:d.url("/api/user/update")}),["NickName","Address"].forEach(function(t){e.model.set(t,{edit:"edit",value:"",readonly:!0,click:function(i){if("edit"==this.data.edit)e.model.set(t,{value:"确定",readonly:null,edit:"editing"}),e["$"+t].focus();else{if(e.model.data.user[t]!=this.data.input){var a={userid:e.user.ID,Auth:e.user.Auth};a[t]=this.data.input,e.setMemberInfo(a)}e.model.set(t,{readonly:!0,value:"",edit:"edit"})}}}),e["$"+t]=e.model.$el.find('[sn-model="'+t+'.input"]')})},onShow:function(){var e=this,t=localStorage.getItem("user");t?(e.user=t=JSON.parse(t),""===t.Avatars&&(t.Avatars=null),this.loading=new o({url:"/api/user/get",check:!1,checkData:!1,params:{userid:t.ID,auth:t.Auth},$el:this.$el,success:function(i){e.user=t=a.extend(t,i.data),""===t.Avatars?t.Avatars=null:t.Avatars=t.Avatars+"?v="+localStorage.getItem("photo_ver"),localStorage.setItem("user",JSON.stringify(t)),e.model.set({user:t,"NickName.input":t.NickName,"Address.input":t.Address})}}),this.loading.load()):this.forward("/login")},onDestory:function(){}})});define("template/index",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div sn-binding="class:menu"></div> <div sn-binding="html:title,class:titleClass"></div> <div class="head_search_btn"><b class="btn_small js_comment" style="display:none">发表评论</b></div> </header> <div class="main" data-index="0"> <ul class="recommend_list js_comment_list"> <li class="recommend_item" sn-repeat="item in data0" sn-binding="data-id:item.ID,data-type:item.Type"> <img sn-binding="src:item.Pic" /> <div class="recommend_name" sn-binding="html:item.Name"></div> <div class="recommend_fav" sn-binding="html:item.Favorite"></div> </li> </ul> </div> <div class="main" style="display:none" data-index="1"> </div> <div class="main" style="display:none" data-index="2"> <ul class="recommend_list activity_list"> <li class="recommend_item" sn-repeat="item in data2" sn-binding="data-id:item.ID"> <a sn-binding="href:item.ID|format:\'/activity/{0}\'" forward> <img sn-binding="src:item.Pic" /> <div class="recommend_name" sn-binding="html:item.Name"></div> <div class="recommend_fav" sn-binding="html:item.Favorite"></div> </a> </li> </ul> </div> <div class="main" style="display:none" data-index="3"> <ul class="quan_list"> <li class="quan_item" sn-repeat="item in data3" sn-binding="data-id:item.ID"> <div class="quan_user"> <img sn-binding="src:item.Avatars" /> <div class="bd"> <h2 sn-binding="html:item.NickName|or:item.Mobile"></h2> <div class="time" sn-binding="html:item.InsertTime|date:\'MM-dd hh:ss\'"></div> </div> <div class="ft"> <span class="quanli_reply" sn-binding="html:item.Reply|length"></span> <span class="quanli_up" sn-binding="html:item.Up"></span> </div> </div> <div class="quan_con" sn-binding="html:item.Content"></div> <div class="quan_item quan_reply" sn-repeat="reply in item.Reply" sn-binding="data-id:item.ID,data-at:reply.NickName|or:reply.Mobile"> <div class="quan_user"> <img sn-binding="src:reply.Avatars" /> <div class="bd"> <h2 sn-binding="html:reply.NickName|or:reply.Mobile"></h2> <div class="time" sn-binding="html:reply.InsertTime|date:\'MM-dd hh:ss\'"></div> </div> <div class="ft"> <span class="quanli_reply"></span> </div> </div> <div class="quan_con" sn-binding="html:reply.Content"></div> </div> </li> </ul> </div> <ul class="footer"> <li class="curr">推荐</li> <li>目的地</li> <li>活动</li> <li>驴友圈</li> </ul>';return __},helpers:{}});return T.template=T.html,T});define("template/myactivity",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main"> <ul class="myactivity"> <li sn-repeat="item in data" sn-binding="data-id:item.ID"> <div> <b sn-binding="html:item.Name"></b> <span sn-binding="html:item.JoinTime|date:\'MM-dd hh:mm\'"></span> </div> <em sn-binding="class:item.StatusID|format:\'myact_status{0}\',html:item.Status"></em> </li> </ul> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/myactivity",["images/style.css"],function(e,i,t){{var a=e("$"),s=e("util"),n=e("activity"),l=e("../widget/loading"),d=e("../core/model"),r=e("../widget/scroll");e("animation")}return n.extend({events:{"tap .myactivity > li[data-id]":function(e){var i=a(e.currentTarget);this.forward("/activity/"+i.data("id")+"?from="+this.route.url)}},swipeRightBackAction:"/",onCreate:function(){var e=this,i=this.$(".main");r.bind(i),this.model=new d.ViewModel(this.$el,{back:"/",title:"我的活动"});var t=new l({url:"/api/user/activity_list",$el:this.$el,success:function(i){e.model.set("data",i.data)},append:function(i){e.model.get("data").append(i.data)}});e.user=s.store("user"),e.user&&t.setParam({UserID:e.user.ID,Auth:e.user.Auth}).load()},onShow:function(){var e=this;e.user=s.store("user"),e.user||e.forward("/login?success="+this.route.url+"&from="+this.route.url)},onDestory:function(){}})});define("template/settings",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main"> <div class="settings"> </div> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/mycomments",["images/style.css"],function(t,e,i){{var n=t("$"),r=t("util"),s=t("activity"),a=t("../widget/loading"),o=t("../core/model"),l=t("../widget/scroll");t("animation")}return s.extend({events:{"tap .quanli_reply":function(t){var e=n(t.currentTarget),i=e.closest("[data-id]"),s=i.data("id");r.store("replyAt","@"+i.data("at")),this.forward("/reply/"+s+"?from="+this.route.url)}},swipeRightBackAction:"/",onCreate:function(){var t=this,e=this.$(".main");l.bind(e),this.model=new o.ViewModel(this.$el,{back:"/",title:"我的评论"});var i=new a({url:"/api/user/comment_list",$el:this.$el,success:function(e){t.model.set("comments",e.data)},append:function(e){t.model.get("comments").append(e.data)}});t.user=r.store("user"),t.user&&i.setParam({UserID:t.user.ID,Auth:t.user.Auth}).load()},onShow:function(){var t=this;t.user=r.store("user"),t.user||t.forward("/login?success="+this.route.url+"&from="+this.route.url)},onDestory:function(){}})});define("template/login",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div sn-binding="html:title" class="head_title"></div> <div class="head_back" sn-binding="data-back:back"></div> </header> <div class="main"> <div class="login_form"> <ul class="form"> <li><input placeholder="输入手机号" sn-model="mobile" /></li> <li><input placeholder="输入密码" sn-model="password" type="password" /></li> </ul> <div class="login_btn"><b class="btn_large js_login">登录</b> </div> <div class="login_notice"><a href="/register" forward>我要注册</a> | <a href="/forget" forward>忘记密码？</a></div> </div> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/login",["images/style.css"],function(t,e,i){var r=(t("$"),t("util")),s=t("activity"),a=t("../widget/loading"),o=t("../core/model"),l=t("../widget/scroll"),u=(t("animation"),t("util/md5"));return s.extend({events:{"tap .js_login:not(.disabled)":function(){var t=this.model.get("mobile"),e=this.model.get("password");return t&&r.validateMobile(t)?e?void this.loading.setParam({mobile:t,password:u.md5(e)}).load():void sl.tip("请输入密码"):void sl.tip("请输入正确的手机")}},swipeRightBackAction:"/",onCreate:function(){var t=this,e=this.$(".main");l.bind(e),this.model=new o.ViewModel(this.$el,{title:"登录",back:this.route.queries.from||"/"}),this.loading=new a({url:"/api/user/login",method:"POST",check:!1,checkData:!1,$el:this.$el,xhrFields:{withCredentials:!0},success:function(e){e.success?(r.store("user",e.data),t.back(t.route.queries.success||"/")):sl.tip(e.msg)},error:function(t){sl.tip(t.msg)}})},onShow:function(){},onDestory:function(){}})});define("views/about",["images/style.css"],function(t,e,i){{var s=(t("$"),t("util"),t("activity")),o=(t("../widget/extend/loading"),t("../core/model")),l=t("../widget/scroll");t("animation")}return s.extend({events:{},swipeRightBackAction:"/settings",onCreate:function(){var e=this.$(".main");l.bind(e),this.model=new o.ViewModel(this.$el,{back:"/settings",title:"关于我们"})},onShow:function(){},onDestory:function(){}})});define("template/mycomments",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main"> <ul class="quan_list"> <li class="quan_item" sn-repeat="item in comments" sn-binding="data-id:item.ID"> <div class="quan_user"> <img sn-binding="src:item.Avatars" /> <div class="bd"> <h2 sn-binding="html:item.NickName|or:item.Mobile"></h2> <div class="time" sn-binding="html:item.InsertTime|date:\'MM-dd hh:ss\'"></div> </div> <div class="ft"> <span class="quanli_reply" sn-binding="html:item.Reply|length"></span> <span class="quanli_up" sn-binding="html:item.Up"></span> </div> </div> <div class="quan_con" sn-binding="html:item.Content"></div> <div class="quan_item quan_reply" sn-repeat="reply in item.Reply" sn-binding="data-id:item.ID,data-at:reply.NickName|or:reply.Mobile"> <div class="quan_user"> <img sn-binding="src:reply.Avatars" /> <div class="bd"> <h2 sn-binding="html:reply.NickName|or:reply.Mobile"></h2> <div class="time" sn-binding="html:reply.InsertTime|date:\'MM-dd hh:ss\'"></div> </div> <div class="ft"> <span class="quanli_reply"></span> </div> </div> <div class="quan_con" sn-binding="html:reply.Content"></div> </div> </li> </ul> </div>';return __},helpers:{}});return T.template=T.html,T});define("template/destination",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main destwrap"> <div class="destimg"> <img sn-binding="src:data.MiddlePic" /> <div class="destfav" sn-binding="html:data.Favorite"></div> <h1 sn-binding="html:data.Name"></h1> </div> <div class="destinfo"> <h2>详情</h2> <div class="destcontent" sn-binding="html:data.Content"></div> </div> <div class="destinfo"> <h2><span class="destcomment js_comment">发表评论</span>评论</h2> <div class="destcontent"> <ul class="quan_list"> <li class="quan_item" sn-repeat="item in comments" sn-binding="data-id:item.ID"> <div class="quan_user"> <img sn-binding="src:item.Avatars" /> <div class="bd"> <h2 sn-binding="html:item.NickName|or:item.Mobile"></h2> <div class="time" sn-binding="html:item.CommentTime|date:\'MM-dd hh:ss\'"></div> </div> </div> <div class="quan_con" sn-binding="html:item.Content"></div> </li> </ul> </div> </div> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/destination",["images/style.css"],function(t,e,i){{var r=(t("$"),t("util"),t("activity")),a=t("../widget/loading"),o=t("../core/model"),l=t("../core/promise"),c=t("../widget/scroll");t("animation")}return r.extend({events:{"tap .js_comment":function(){this.forward("/destcomment/"+this.route.data.id)}},onCreate:function(){var t=this;this.promise=new l,this.$main=this.$(".main"),c.bind(this.$main),o.Filter.precent=function(t){return parseFloat(t)+"%"},this.model=new o.ViewModel(this.$el,{title:"目的地详情",back:this.route.queries.from||"/"}),this.loading=new a({url:"/api/destination/get",params:{id:this.route.data.id},check:!1,checkData:!1,$el:this.$el,$content:this.$main.children(":first-child"),$scroll:this.$main,success:function(e){t.promise.then(function(){t.model.set(e)}),localStorage.setItem("destination",JSON.stringify(e.data))}}),this.loading.load(),this.comments=new a({url:"/api/destination/comment_list",$el:t.$(".quan_list"),success:function(e){t.model.set("comments",e.data)},append:function(e){t.model.get("comments").append(e.data)}}),this.comments.load(),t.onResult("destcomment_success",function(){t.comments.reload()})},onLoad:function(){this.promise.resolve()},onDestory:function(){}})});define("views/search",["images/style.css"],function(t,e,i){{var r=(t("$"),t("util"),t("activity")),a=t("../widget/extend/loading"),o=t("../core/model"),l=t("../widget/scroll");t("animation")}return r.extend({events:{'tap [sn-repeat-name="data"][data-id]':function(t){this.forward("/teacher/"+t.currentTarget.getAttribute("data-id")+"?from="+this.route.url)},"tap .js_search":function(t){var e=this.getParam(this.model.data.keywords);this.loading.setParam(e).reload()}},getParam:function(t){var e={compare_field:"q"==t?"":t};return this.route.queries.course_category&&(e.course_category=this.route.queries.course_category),e},onCreate:function(){var t=this,e=this.$(".main");l.bind(e,{refresh:function(e,i){t.loading.reload({showLoading:!1},function(t,n){t?i(t):e(n)})}}),this.loading=new a({url:"/teacher/teacher_list",check:!1,checkData:!1,params:this.getParam(this.route.data.keywords),$el:this.$el,$content:e.children(":first-child"),$scroll:e,success:function(e){e.data.length>=10?e.total=(this.pageIndex+1)*this.pageSize:e.data&&e.data.length||this.showError({showReload:!1,msg:"搜索不到您要找的老师"}),console.log(t.model),t.model.set(e)},append:function(e){e.data.length>=10&&(e.total=(this.pageIndex+1)*this.pageSize),t.model.get("data").append(e.data)}}),this.model=new o.ViewModel(this.$el,{}),this.loading.load()},onShow:function(){},onDestory:function(){}})});define("views/activity",["images/style.css"],function(t,e,i){{var s=(t("$"),t("util")),r=t("activity"),a=t("../widget/loading"),o=t("../core/model"),l=t("../core/promise"),c=t("../widget/scroll");t("animation")}return r.extend({events:{"tap .js_submit:not(.disabled)":function(t){this.user?(this.$submit.addClass("disabled"),this.submit.setParam({UserID:this.user.ID,Auth:this.user.Auth}).load()):this.forward("/login?success="+this.route.url+"&from="+this.route.url)},"tap .js_comment":function(){this.forward("/actcomment/"+this.route.data.id)}},onCreate:function(){var t=this;this.promise=new l,this.$main=this.$(".main"),c.bind(this.$main),o.Filter.precent=function(t){return parseFloat(t)+"%"},this.model=new o.ViewModel(this.$el,{title:"活动详情",back:this.route.queries.from||"/"}),this.loading=new a({url:"/api/activity/get",params:{id:this.route.data.id},check:!1,checkData:!1,$el:this.$el,$content:this.$main.children(":first-child"),$scroll:this.$main,success:function(e){t.promise.then(function(){t.model.set(e)}),localStorage.setItem("destination",JSON.stringify(e.data))}}),this.loading.load(),this.$submit=this.$el.find(".js_submit"),this.submit=new a({url:"/api/activity/signup",params:{id:this.route.data.id},check:!1,checkData:!1,$el:this.$el,success:function(e){e.success?(sl.tip("报名成功！"),t.model.set("data.SignUpQty",t.model.data.data.SignUpQty+1)):sl.tip(e.msg),t.$submit.removeClass("disabled")}}),this.comments=new a({url:"/api/activity/comment_list",$el:t.$(".quan_list"),success:function(e){t.model.set("comments",e.data)},append:function(e){t.model.get("comments").append(e.data)}}),this.comments.load(),t.onResult("actcomment_success",function(){t.comments.reload()})},onLoad:function(){this.promise.resolve()},onShow:function(){this.user=s.store("user")},onDestory:function(){}})});define("template/search",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" data-back="/"></div> <div class="head_search"><input placeholder="输入姓名或手机号搜索老师" sn-model="keywords" /></div> <div class="head_search_btn"><b class="btn_small js_search">搜索</b></div> </header> <div class="main"> <ul class="search_list"> <li class="search_item" sn-repeat="item in data" sn-binding="data-id:item.teacher_id"> <div class="s_teacher"><img class="search_photo" sn-binding="src:item.head_photo" /> <ul class="s_teacher_basic"> <li><strong class="s_name" sn-binding="html:item.teacher_name"></strong><em sn-binding="html:item.discipline"></em><i sn-binding="html:item.price|round|concat:\'元/小时\'"></i></li> <li><span class="s_area" sn-binding="html:item.area"></span><span class="s_age" sn-binding="html:item.teaching_age|concat:\'教龄\'"></span></li> <li class="s_data"><span sn-binding="html:item.class_hours_number|concat:\'小时\'"></span><span sn-binding="html:item.students_number|concat:\'个\'"></span><span sn-binding="html:item.praise_rate"></span><span sn-binding="html:item.continue_rate"></span></li> </ul> </div> <!--<div class="s_honor" sn-binding="html:item.honor|format:\'获得荣誉：{0}\'"></div>--> <ul class="s_cert"> <li class="cert" sn-binding="display:item.certification_flag">身份认证</li> <li class="t_cert" sn-binding="display:item.teacher_certification_flag">教师资格认证</li> <li class="education" sn-binding="display:item.education_flag">学历认证</li> </ul> </li> </ul> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/settings",["images/style.css"],function(t,e,i){{var r=(t("$"),t("util"),t("activity")),o=(t("../widget/loading"),t("../core/model")),l=t("../widget/scroll");t("animation")}return r.extend({events:{"tap .js_bind:not(.disabled)":function(){},"tap .logout":function(){localStorage.getItem("member")?(localStorage.removeItem("member"),this.back("/")):this.forward("/login")}},swipeRightBackAction:"/",onCreate:function(){var e=this.$(".main");l.bind(e),this.model=new o.ViewModel(this.$el,{back:"/",title:"设置",settings:[{title:"关于我们",href:"/about"}]});var i=localStorage.getItem("member");i?(i=JSON.stringify(i),this.model.set("logout","退出当前账号")):this.model.set("logout","立即登录")},onShow:function(){},onDestory:function(){}})});define("template/comment",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> <div class="head_search_btn"><b class="btn_small js_submit">提交</b></div> </header> <div class="main"> <textarea class="txt_comment" sn-model="content" placeholder="写评论..."></textarea> </div>';return __},helpers:{}});return T.template=T.html,T});define("template/activity",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main destwrap actwrap"> <div class="destimg"> <img sn-binding="src:data.Pic" /> <div class="destfav" sn-binding="html:data.Favorite"></div> <h1 sn-binding="html:data.Name"></h1> </div> <div class="activity_info"> <div class="act_signup"><b class="act_signup_num" sn-binding="html:data.SignUpQty"></b>报名</div> <div class="act_time"><text sn-binding="html:data.StartTime|date:\'yyyy年MM月dd日 hh:mm\'"></text>~<text sn-binding="html:data.FinishTime|date:\'yyyy年MM月dd日 hh:mm\'"></text></div> <div class="act_address" sn-binding="html:data.Address"></div> </div> <div class="destinfo"> <h2>详情</h2> <div class="destcontent" sn-binding="html:data.Content"></div> </div> <div class="destinfo"> <h2><span class="destcomment js_comment">发表评论</span>评论</h2> <div class="destcontent"> <ul class="quan_list"> <li class="quan_item" sn-repeat="item in comments" sn-binding="data-id:item.ID"> <div class="quan_user"> <img sn-binding="src:item.Avatars" /> <div class="bd"> <h2 sn-binding="html:item.NickName|or:item.Mobile"></h2> <div class="time" sn-binding="html:item.CommentTime|date:\'MM-dd hh:ss\'"></div> </div> </div> <div class="quan_con" sn-binding="html:item.Content"></div> </li> </ul> </div> </div> </div> <footer class="signup_bar"> <b class="btn_signup js_submit">我要报名</b> </footer> ';return __},helpers:{}});return T.template=T.html,T});define("template/reply",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<div class="reply"> <input type="text" sn-model="content" sn-binding="value:content" /> <b class="btn_small js_reply">回复评论</b> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/reply",["images/style.css"],function(t,e,i){{var s=(t("$"),t("util")),a=t("activity"),r=t("../widget/loading"),o=t("../core/model");t("../widget/scroll"),t("animation")}return a.extend({events:{tap:function(t){t.target==this.el&&this.back("/")},"tap .js_reply:not(.disabled)":function(){var t=this;t.model.data.content?t.loading.setParam({ID:this.route.data.id,UserID:t.user.ID,Auth:t.user.Auth,Content:t.model.data.content}).load():sl.tip("请填写评论")}},swipeRightBackAction:"/",toggleAnim:"fade",className:"transparent",onCreate:function(){var t=this;this.swipeRightBackAction=t.route.queries.from||"/",this.model=new o.ViewModel(this.$el,{content:s.store("replyAt")+" "}),this.loading=new r({url:"/api/quan/reply",$el:this.$el,checkData:!1,success:function(e){e.success&&(sl.tip("评论成功"),t.setResult("comment_success"),t.back(t.route.queries.from||"/"))}})},onShow:function(){var t=this;t.user=s.store("user"),t.user||t.forward("/login?success="+this.route.url+"&from="+this.route.url),t.$el.find("input").focus()},onDestory:function(){}})});define("template/comment",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> <div class="head_search_btn"><b class="btn_small js_submit">提交</b></div> </header> <div class="main"> <textarea class="txt_comment" sn-model="content" placeholder="写评论..."></textarea> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/comment",["images/style.css"],function(t,e,i){{var s=(t("$"),t("util")),a=t("activity"),r=t("../widget/loading"),o=t("../core/model"),l=t("../widget/scroll");t("animation")}return a.extend({events:{"tap .js_submit:not(.disabled)":function(){var t=this;t.model.data.content?t.loading.setParam({UserID:t.user.ID,Auth:t.user.Auth,Content:t.model.data.content}).load():sl.tip("请填写评论")}},swipeRightBackAction:"/",onCreate:function(){var t=this,e=this.$(".main");l.bind(e),this.model=new o.ViewModel(this.$el,{back:"/",title:"评论"}),this.loading=new r({url:"/api/quan/add_comment",$el:this.$el,checkData:!1,success:function(e){e.success&&(sl.tip("评论成功"),t.setResult("comment_success"),t.back("/"))}})},onShow:function(){var t=this;t.user=s.store("user"),t.user||t.forward("/login?success="+this.route.url+"&from="+this.route.url)},onDestory:function(){}})});define("template/comment",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> <div class="head_search_btn"><b class="btn_small js_submit">提交</b></div> </header> <div class="main"> <textarea class="txt_comment" sn-model="content" placeholder="写评论..."></textarea> </div>';return __},helpers:{}});return T.template=T.html,T});define("template/register",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div sn-binding="html:title" class="head_title"></div> <div class="head_back" sn-binding="data-back:back"></div> </header> <div class="main"> <div class="login_form"> <ul class="form"> <li><input placeholder="输入手机号" sn-model="mobile" /></li> <li><input placeholder="验证码" sn-model="smsCode" type="text" /> <b class="js_valid btn_middle" sn-binding="html:valid"></b></li> <li><input placeholder="设置密码" sn-model="password" type="password" /></li> <li><input placeholder="再次输入确认密码" sn-model="password1" type="password" /></li> </ul> <div class="login_btn"><b class="btn_large js_bind">确定注册</b> </div> </div> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/actcomment",["images/style.css"],function(t,e,i){{var s=(t("$"),t("util")),a=t("activity"),r=t("../widget/loading"),o=t("../core/model"),l=t("../widget/scroll");t("animation")}return a.extend({events:{"tap .js_submit:not(.disabled)":function(){var t=this;t.model.data.content?t.loading.setParam({ActivityID:t.route.data.id,UserID:t.user.ID,Auth:t.user.Auth,Content:t.model.data.content}).load():sl.tip("请填写评论")}},onCreate:function(){var t=this,e=this.$(".main");l.bind(e),this.model=new o.ViewModel(this.$el,{back:"/",title:"评论"}),this.loading=new r({url:"/api/activity/add_comment",$el:this.$el,checkData:!1,success:function(e){e.success&&(sl.tip("评论成功"),t.setResult("actcomment_success"),t.back("/activity/"+t.route.data.id))}})},onShow:function(){var t=this;t.user=s.store("user"),t.user||t.forward("/login?success="+this.route.url+"&from="+this.route.url)},onDestory:function(){}})});define("views/destcomment",["images/style.css"],function(t,e,i){{var s=(t("$"),t("util")),a=t("activity"),r=t("../widget/loading"),o=t("../core/model"),l=t("../widget/scroll");t("animation")}return a.extend({events:{"tap .js_submit:not(.disabled)":function(){var t=this;t.model.data.content?t.loading.setParam({DestID:t.route.data.id,UserID:t.user.ID,Auth:t.user.Auth,Content:t.model.data.content}).load():sl.tip("请填写评论")}},swipeRightBackAction:"/",onCreate:function(){var t=this,e=this.$(".main");l.bind(e),this.model=new o.ViewModel(this.$el,{back:"/",title:"评论"}),this.loading=new r({url:"/api/destination/add_comment",$el:this.$el,checkData:!1,success:function(e){e.success&&(sl.tip("评论成功"),t.setResult("destcomment_success"),t.back("/destination/"+t.route.data.id))}})},onShow:function(){var t=this;t.user=s.store("user"),t.user||t.forward("/login?success="+this.route.url+"&from="+this.route.url)},onDestory:function(){}})});define("views/register",["images/style.css"],function(t,e,i){var s=(t("$"),t("util")),a=t("activity"),r=t("../widget/loading"),o=t("../core/model"),l=t("../widget/scroll"),d=(t("animation"),t("util/md5"));return a.extend({events:{"tap .js_bind:not(.disabled)":function(){var t=this.model.data.mobile,e=this.model.data.password,i=this.model.data.password1,n=this.model.data.smsCode;return t&&s.validateMobile(t)?e!=i?void sl.tip("两次密码输入不一致"):n?void this.loading.setParam({mobile:t,password:d.md5(e),smsCode:n}).load():void sl.tip("请输入验证码"):void sl.tip("请输入正确的手机")},"tap .js_valid:not(.disabled)":function(t){var e=this.model.get("mobile");return e&&s.validateMobile(e)?(this.$valid.addClass("disabled"),this.valid.setParam({mobile:this.model.data.mobile}),void this.valid.load()):void sl.tip("请输入正确的手机")}},validTimeout:function(){var t=this,e=localStorage.getItem("valid_time");if(e&&parseInt(e)>60){if(e=Math.round((new Date(parseInt(e)).getTime()-Date.now())/1e3),0>=e)return;t.$valid.addClass("disabled"),setTimeout(function(){0>=e?(t.$valid.removeClass("disabled"),t.model.set("valid","获取验证码"),localStorage.removeItem("valid_time")):(t.model.set("valid",e+"秒"),e--,setTimeout(arguments.callee,1e3))},1e3)}},onCreate:function(){var t=this,e=this.$(".main");l.bind(e),this.model=new o.ViewModel(this.$el,{title:"注册",valid:"获取验证码",back:this.route.queries.from||"/login"}),this.loading=new r({url:"/api/user/register",method:"POST",check:!1,checkData:!1,$el:this.$el,success:function(e){e.success?(localStorage.setItem("user",JSON.stringify(e.data)),t.back(t.route.queries.success||"/")):sl.tip(e.msg)},error:function(t){sl.tip(t.msg)}}),this.valid=new r({url:"/api/user/send_sms",method:"POST",params:{mobile:t.model.data.mobile},check:!1,checkData:!1,$el:this.$el,success:function(e){e.success?(localStorage.setItem("valid_time",Date.now()+6e4),t.validTimeout()):sl.tip(e.msg)}}),t.$valid=this.$(".js_valid"),t.validTimeout()},onShow:function(){},onDestory:function(){}})});