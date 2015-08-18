define("template/index",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div sn-binding="class:menu"></div> <div sn-binding="html:title,class:titleClass"></div> <div class="head_msg" data-forward="/messages"> <i>3</i> </div> </header> <div class="main js_usescroll" data-index="0" sn-binding="class:isLogin|equal:true:\'\':\'isnotlogin\'"> <div sn-binding="display:isLogin" class="home_bd"> <div class="home_vip"> <div class="rainbow"> <ul class="rainbow_points"> <li>0</li> <li>1000</li> <li>5000</li> <li>10000</li> <li>50000</li> </ul> <ul class="rainbow_vip"> <li>银卡</li> <li>金卡</li> <li>钻石</li> <li>VIP</li> <li>SVIP</li> </ul> <div class="rainbow_bd"> <div class="point" sn-binding="html:point"></div> <div class="desc" sn-binding="html:currentLevel"></div> <div class="point_tip"> <span sn-binding="html:nextLevel"></span><b>活力值</b> <p>即可享有<em sn-binding="html:vip"></em>特权</p> </div> </div> </div> <div class="home_points_bg"> <div class="home_points"></div> <div class="home_points"></div> <div class="home_points_cursor"></div> </div> </div> <ul class="home_ad"> <li sn-repeat="item in ads"> <img sn-binding="src:item.Src" sn-on="tap:open:item.Url" /> </li> </ul> </div> <div sn-binding="display:isLogin|not" class="home_notlogin"> <div class="home_mask"></div> <div class="home_text" data-forward="/login"> <h1></h1> <h2>让回家的灯，为爱亮起来。</h2> <h3>开启时尚居家之旅</h3> <h4>LIFE STARTS HERE</h4> </div> <div class="launch"> <img src="images/launch0.png" /> <img src="images/launch1.png" class="launch_hide" /> <img src="images/launch2.png" class="launch_hide" /> </div> </div> </div> <div class="main" style="display:none" data-index="1"> </div> <div class="main" style="display:none" data-index="2"> </div> <div class="main home_my" style="display:none" data-index="3"> <div class="my"> <div class="card"> <div class="level"> <span sn-binding="html:currentLevel"></span> <span sn-binding="html:point"></span> </div> <div class="point" sn-binding="html:id|format:\'ID:{0}\'"></div> <div class="barcode" sn-binding="html:barcode"> </div> <div class="mobile" sn-binding="html:user.Mobile"></div> </div> <ul class="myabs"> <li data-forward="/month"> <b>我的月礼</b> <span>您当前享有<em>12个月</em>会员礼免费领特权。</span> </li> <li data-forward="/mycard"> <b>我的卡券</b> <span>您现在拥有优惠券<em>8</em>张。</span> </li> <li data-forward="/mypoint"> <b>我的积分</b> <span>您当前积分为<em>8</em>。</span> </li> <li data-forward="/myorder"> <b>我买到的</b> <span>您目前在ABS共完成<em>8</em>次购物。</span> </li> </ul> </div> </div> <ul class="footer" sn-binding="display:isLogin"> <li class="curr">首页</li> <li>马上购物</li> <li>附近门店</li> <li>我</li> </ul>';return __},helpers:{}});return T.template=T.html,T});define("views/index",["images/style.css"],function(e,i,s){var t=e("$"),n=e("util"),a=e("activity"),l=e("bridge"),o=e("../widget/loading"),r=(e("../widget/slider"),e("../core/model")),c=e("../widget/scroll"),u=(e("../widget/barcode"),e("../util/barcode")),p=e("animation"),v=[1e3,4e3,5e3,45e3],h=function(e){for(var i=0,s=0;s<v.length;s++){if(e<=v[s]){i+=25*e/v[s];break}i+=25,e-=v[s]}return i};return a.extend({events:{tap:function(e){e.target==this.el&&this.back("/")},"tap .head_menu":function(e){this.forward("/menu")},"tap .js_comment_list [data-id]":function(e){},"tap .footer li":function(e){var i=t(e.currentTarget);if(!i.hasClass("curr")){var s=i.index();i.addClass("curr").siblings(".curr").removeClass("curr"),this.$main.eq(s).show().siblings(".main").hide()}}},swipeRightForwardAction:"/menu",className:"home",titles:["欢迎来到ABS会员俱乐部","马上购物","附件门店","我"],onCreate:function(){var e=this;this.model=new r.ViewModel(this.$el,{menu:"head_menu",titleClass:"head_title",title:"ABS + CLUB",isLogin:!1,open:function(e,i){l.open(i)}});var i=this.$main=this.$(".main");c.bind(i.filter(".js_usescroll"),{useScroll:!0}),c.bind(i.filter(":not(.js_usescroll)"));new o({url:"",$el:i.eq(3),$content:i.eq(3).children(":first-child"),$scroll:i.eq(3),success:function(i){e.model.set("data"+index,i.data)},append:function(i){e.model.get("data"+index).append(i.data)}});this.$points=this.$(".home_points"),this.$cursor=this.$(".home_points_cursor"),this.userLoading=new o({url:"/api/user/get",check:!1,checkData:!1,$el:this.$el,success:function(i){t.extend(e.user,i.data),n.store("user",e.user),e.model.set({user:e.user}),e.showPoints()}}),this.adLoading=new o({url:"/api/settings/ad_list?name=index1",check:!1,checkData:!1,$el:this.$el.find(".home_ad"),success:function(i){e.model.set({ads:i.data});var s=e.$(".home_ad > li");s.each(function(e){var i=this;setTimeout(function(){i.className="toggle"},100*(e+1))})}}),this.adLoading.load();var a=this.$(".launch img"),d=this.$(".home_mask").on(t.fx.transitionEnd,function(e){if(d.hasClass("toggle")){d.removeClass("toggle");var i=a.filter(":not(.launch_hide)").addClass("launch_hide");a.eq(i.index()+1==a.length?0:i.index()+1).removeClass("launch_hide")}});setTimeout(function(){d.addClass("toggle"),setTimeout(arguments.callee,4e3)},4e3)},setRainbow:function(){var a,l,e=this,i=this.user.Amount,s=h(i),t=s/50*117-117,d=["银卡会员","金卡会员","钻石会员","VIP会员","SVIP会员","无敌会员"];e.model.set("vip",1e3>i?(a=0,l=1e3-i,d[1]):5e3>i?(a=1,l=5e3-i,d[2]):1e4>i?(a=2,l=1e4-i,d[3]):5e4>i?(a=3,l=5e4-i,d[4]):(a=4,l="∞",d[5])),this.$(".rainbow_vip :nth-child("+(a+1)+")").addClass("curr"),e.model.set("nextLevel","+"+l),e.model.set("currentLevel",d[a]),p.animate(function(s){var a=p.step(-117,t,s),l=Math.round(p.step(0,i,s)),o=n.circlePoint(0,0,91,90-a);o.x>0?0==t?o.x=0:55>t?(o.x-=4,o.y+=2):80>t?o.x-=7:(o.x-=9,o.y+=2):o.y+=2,e.model.set("point",l),e.$cursor.css({"-webkit-transform":"rotate("+t+"deg)",top:91-o.y,left:91+o.x})},300,"ease-out"),s>50&&this.$points.eq(0).animate({rotate:"0deg"},300,"ease-out"),this.$points.eq(1).animate({rotate:t+"deg"},300,"ease-out")},onShow:function(){var e=this;e.user=n.store("user");var i=!!e.user;e.model.set("isLogin",i),i&&(e.showPoints(),e.model.set("barcode",u.code93(e.user.Mobile).replace(/0/g,"<em></em>").replace(/1/g,"<i></i>")).set("user",e.user),!this.userLoaded&&(this.userLoaded=!0)&&this.userLoading.setParam({UserID:e.user.ID,Auth:e.user.Auth}).load())},showPoints:function(){this.setRainbow(this.user.Amount),this.$(".point_tip").addClass("show")},onPause:function(){},onLoad:function(){},onDestory:function(){}})});define("template/menu",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<div class="menu_bd"> <div class="menu_user" sn-binding="data-back:memberUrl"> <div class="menu_username"> <h1> <text sn-binding="html:user.UserName|or:user.Mobile"></text> <span>补全信息</span> </h1> <h2 sn-binding="html:user.BirthDay|date:\'yyyy/MM/dd\'"></h2> </div> </div> <ul class="menu_list menu_my"> <li data-forward="/month">我的月礼</li> <li data-forward="/mycard">我的卡券</li> <li data-forward="/mypoint">我的积分</li> <li data-forward="/myorder">我买到的</li> </ul> <ul class="menu_list menu_service"> <li data-forward="/guide">新手指南</li> <li><a href="tel:4208205077">联系客服</a></li> </ul> <ul class="menu_list menu_settings"> <li data-forward="/settings">设置</li> </ul> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/menu",["images/style.css"],function(e,i,s){var n=(e("$"),e("util"),e("activity")),l=e("bridge"),r=e("core/model"),o=e("../widget/scroll");e("../widget/loading");return n.extend({toggleAnim:"menu",className:"menu",events:{tap:function(e){},"tap [data-logout]":function(e){}},swipeLeftBackAction:"/",onCreate:function(){o.bind(this.$(".menu_bd")),l.hasStatusBar&&this.$el.find(".fix_statusbar").addClass("fix_statusbar"),this.model=new r.ViewModel(this.$el,{memberUrl:"/member"});var i=localStorage.getItem("user");i?(this.user=i=JSON.parse(i),this.model.set({logoutOrLogin:"退出",user:i})):this.model.set({logoutOrLogin:"登录",user:{NickName:"未登录"}})},onShow:function(){var e=this;e.user&&e.user.Avatars&&e.model.set("user.Avatars",e.user.Avatars+"?v="+localStorage.getItem("avatars_ver"))},onDestory:function(){}})});define("template/about",function(require){var util=require("util"),T={html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main"> <div class="aboutus"> 邻师是一个针对0～18岁学生（家长）和教师的教育资源整合平台，我们专门帮助小微培训机构，教师工作室及教师个人进行品牌塑造和市场推广，我们希望让老师能够招到更多的优质学生，让学生找到更合适自己的老师。 <img src="'+util.encodeHTML(webresource("images/aboutus.jpg"))+'" /> <div class="aboutus_ver">发现身边好老师</div> </div> </div> ';return __},helpers:{}};return T.template=T.html,T});define("views/about",["images/style.css"],function(e,i,t){var n=(e("$"),e("util"),e("activity")),r=(e("../widget/extend/loading"),e("../core/model")),d=e("../widget/scroll");e("animation");return n.extend({events:{},swipeRightBackAction:"/settings",onCreate:function(){var i=this.$(".main");d.bind(i),this.model=new r.ViewModel(this.$el,{back:"/settings",title:"关于我们"})},onShow:function(){},onDestory:function(){}})});define("template/member",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main scrollview"> <div class="member"> <dl class="member_info"> <dt>登录名</dt> <dd><p sn-binding="html:user.Mobile"></p></dd> <dt>姓名</dt> <dd><input sn-binding="value:user.UserName" sn-model="user.UserName" /></dd> <dt>性别：</dt> <dd> <span class="radio" sn-model="user.Gender" value="1" sn-binding="class:user.Gender|case:\'1\':\'checked\':\'\'">男</span> <span class="radio" sn-model="user.Gender" value="2" sn-binding="class:user.Gender|case:\'2\':\'checked\':\'\'">女</span> </dd> <dt>生日</dt> <dd><input type="text" sn-binding="value:user.BirthDay|date:\'yyyy/MM/dd\'" sn-model="user.BirthDay" /></dd> <dt>所在地</dt> <dd sn-on="tap:showCity"><p sn-binding="html:user.City"></p></dd> <dt>家庭人数</dt> <dd><input sn-binding="value:user.FamilySize" sn-model="user.FamilySize" /></dd> <dt>是否有小孩：</dt> <dd> <span class="radio" sn-model="user.HasChild" value="1" sn-binding="class:user.HasChild|equal:true:\'checked\':\'\'">是</span> <span class="radio" sn-model="user.HasChild" value="0" sn-binding="class:user.HasChild|equal:false:\'checked\':\'\'">否</span> </dd> <dt>小孩生日</dt> <dd><input type="text" sn-binding="value:user.ChildBirthDay" sn-model="user.ChildBirthDay" /></dd> </dl> <div class="member_bar"> <b class="btn_mid" sn-on="tap:submit" sn-binding="class:submiting|equal:true:\'disabled\':\'\'">修改</b> <b class="btn_cancel">取消</b> </div> </div> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/member",["images/style.css"],function(e,i,s){var t=e("$"),a=e("util"),n=e("activity"),l=e("core/model"),r=(e("../widget/scroll"),e("bridge")),o=e("../widget/loading"),c=e("../widget/selector");return n.extend({events:{"tap .radio":function(e){var i=t(e.currentTarget),s=e.currentTarget.getAttribute("value");this.model.set(i.attr("sn-model"),s)}},onCreate:function(){var e=this;e.swipeRightBackAction=this.route.query.from||"/",this.model=new l.ViewModel(this.$el,{title:"个人信息",back:e.swipeRightBackAction,showCity:function(){var s=a.indexOf(e.provinceList,function(i){return i.PRV_ID==e.model.data.user.ProvID});-1!=s&&(e.city.eq(0).index(s),i(e.model.data.user.ProvID)),e.city.show()},submit:function(){this.set("submiting",!0);var i=this.data.user;e.update.setParam({ID:i.ID,Auth:i.Auth,UserName:i.UserName,Gender:i.Gender,BirthDay:i.BirthDay&&a.formatDate(i.BirthDay),ChildBirthDay:i.ChildBirthDay&&a.formatDate(i.ChildBirthDay),CityID:i.CityID,FamilySize:i.FamilySize,HasChild:i.HasChild}).load()}}),this.update=new o({url:"/api/user/update",check:!1,checkData:!1,$el:this.$el,success:function(i){i.success?(a.store("user",e.model.data.user),sl.tip("修改成功")):sl.tip(i.msg),e.model.set("submiting",!1)}}),this.city=new c({options:[{template:"<li><%=PRV_DESC%></li>",data:[],onChange:function(e,s,t){i(t.PRV_ID)}},{template:"<li><%=CTY_DESC%></li>",data:[]}],complete:function(i){e.model.set("user.City",i[1].CTY_DESC),e.model.set("user.CityID",i[1].CTY_ID),e.model.set("user.ProvID",i[1].CTY_PRV_ID)}});var i=function(i){var s=a.find(e.cityList,function(e){return e.CTY_PRV_ID==i});if(s.unshift({CTY_PRV_ID:i,CTY_ID:0,CTY_DESC:"请选择"}),e.city.eq(1).set(s),e.model.data.user){var t=a.indexOf(s,function(i){return i.CTY_ID==e.model.data.user.CityID});-1!=t&&e.city.eq(1).index(t)}};t.get(r.url("/api/user/get_city"),function(s){s.province.unshift({PRV_ID:0,PRV_DESC:"请选择"}),e.city.eq(0).set(s.province),e.provinceList=s.province,e.cityList=s.data,i(s.province[0].PRV_ID)},"json")},onShow:function(){var e=this,i=a.store("user");i?(e.user=i,this.loading=new o({url:"/api/user/get",check:!1,checkData:!1,params:{UserID:i.ID,Auth:i.Auth},$el:this.$el,success:function(s){e.user=i=t.extend(i,s.data),a.store("user",i),e.model.set({user:i,"NickName.input":i.NickName,"Address.input":i.Address})}}),this.loading.load()):this.forward("/login")},onDestory:function(){}})});define("template/settings",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main settings"> <div class="hello"> <div class="name" sn-binding="html:user.UserName|or:\'亲爱的用户\'"></div> <div class="text">你好！</div> </div> <ul class="con"> <li data-forward="/member?from=/settings">账户信息</li> <li>隐私政策</li> </ul> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/settings",["images/style.css"],function(e,i,t){var a=(e("$"),e("util")),n=e("activity"),d=(e("../widget/loading"),e("../core/model")),r=e("../widget/scroll");e("animation");return n.extend({events:{"tap .js_bind:not(.disabled)":function(){},"tap .logout":function(){localStorage.getItem("user")?(localStorage.removeItem("user"),this.back("/")):this.forward("/login")}},swipeRightBackAction:"/",onCreate:function(){var i=this.$(".main");r.bind(i);var t=a.store("user");this.model=new d.ViewModel(this.$el,{back:"/",title:"设置",user:t}),t?this.model.set("logout","退出"):this.model.set("logout","立即登录")},onShow:function(){},onDestory:function(){}})});define("template/login",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='<header> <div sn-binding="html:title" class="head_title"></div> <div class="head_back" sn-binding="data-back:back"></div> </header> <div class="main"> <div class="login_form"> <h1 class="login_hd">注册/登录</h1> <ul class="form"> <li class="form_mobile"><input placeholder="请输入您的手机号码" sn-model="mobile" /></li> <li><input placeholder="请输入短信验证码" sn-model="smsCode" type="text" /><b class="js_valid btn_middle" sn-binding="html:valid"></b></li> </ul> <div class="login_btn"><b class="btn_large js_login">手机号登录</b> </div> </div> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/login",["images/style.css"],function(e,i,t){var s=e("$"),a=e("util"),n=e("activity"),l=e("../widget/loading"),d=e("../core/model"),r=e("../widget/scroll");e("animation");return n.extend({events:{"tap .js_login:not(.disabled)":function(){var e=this.model.get("mobile"),i=this.model.get("smsCode");return e&&a.validateMobile(e)?i?void this.loading.setParam({mobile:e,smsCode:i}).load():void sl.tip("请输入密码"):void sl.tip("请输入正确的手机")},"tap .js_valid:not(.disabled)":function(e){var i=this.model.get("mobile");return i&&a.validateMobile(i)?(this.$valid.addClass("disabled"),this.valid.setParam({mobile:this.model.data.mobile}),void this.valid.load()):void sl.tip("请输入正确的手机")}},swipeRightBackAction:"/",validTimeout:function(){var e=this,i=localStorage.getItem("valid_time");if(i&&parseInt(i)>60){if(i=Math.round((new Date(parseInt(i)).getTime()-Date.now())/1e3),0>=i)return;e.$valid.addClass("disabled"),setTimeout(function(){0>=i?(e.$valid.removeClass("disabled"),e.model.set("valid","获取验证码"),localStorage.removeItem("valid_time")):(e.model.set("valid",i+"秒后再次获取"),i--,setTimeout(arguments.callee,1e3))},1e3)}},onCreate:function(){var e=this,i=this.$(".main");r.bind(i),this.model=new d.ViewModel(this.$el,{title:"快速登录 / 注册",valid:"获取验证码",back:this.route.query.from||"/"}),this.getUser=new l({url:"/api/user/get",check:!1,checkData:!1,$el:this.$el,success:function(){}}),this.loading=new l({url:"/api/user/login",method:"POST",check:!1,checkData:!1,$el:this.$el,success:function(i){i.success?(a.store("user",i.data),e.getUser.setParam({UserID:i.data.UserID,Auth:i.data.Auth}).load(function(t,n){n&&a.store("user",s.extend(i.data,n.data)),e.back(e.route.query.success||"/")})):sl.tip(i.msg)},error:function(e){sl.tip(e.msg)}}),this.valid=new l({url:"/api/user/send_sms",method:"POST",params:{mobile:e.model.data.mobile},check:!1,checkData:!1,$el:this.$el,success:function(i){i.success?(localStorage.setItem("valid_time",Date.now()+6e4),e.validTimeout()):sl.tip(i.msg)},error:function(i){sl.tip(i.msg),e.$valid.removeClass("disabled"),this.hideLoading()}}),e.$valid=this.$(".js_valid"),e.validTimeout()},onShow:function(){},onDestory:function(){}})});define("template/month",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main"> <div class="month_present"> <img /> </div> <div class="month_notice"> 亲，不要忘记啦！您还有<em>x</em>个月的会员礼可以领取哟！ </div> <ul class="month"> <li class="overdue"> <i class="flag">2015年</i> <img /> </li> <li class="get"></li> <li class="curr"><em>立即领取</em></li> <li><span>11月</span></li> <li class="lastmonth"><span>12月</span></li> <li> <i class="flag">2016年</i> <span>1月</span> </li> <li><span>2月</span></li> </ul> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/month",["images/style.css"],function(e,i,t){var n=(e("$"),e("util"),e("activity")),l=e("../widget/loading"),d=e("../core/model"),r=e("../core/promise"),o=e("../widget/scroll");e("animation");return n.extend({events:{"tap .js_comment":function(){this.forward("/destcomment/"+this.route.data.id)}},swipeRightBackAction:"/",onCreate:function(){this.promise=new r,this.$main=this.$(".main"),o.bind(this.$main),this.model=new d.ViewModel(this.$el,{title:"我的月礼",back:this.route.query.from||"/"}),this.loading=new l({url:"/api/destination/get",params:{id:this.route.data.id},check:!1,checkData:!1,$el:this.$el,$content:this.$main.children(":first-child"),$scroll:this.$main,success:function(e){}})},onLoad:function(){},onDestory:function(){}})});define("template/mycard",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main mycard"> <ul class="mycard_hd"> <li sn-binding="class:isOverdue|equal:false:\'curr\':\'\'" sn-on="tap:isOverdue=false">待使用</li> <li sn-binding="class:isOverdue|equal:false:\'\':\'curr\'" sn-on="tap:isOverdue=true">已过期</li> </ul> <ul class="mycard_con" sn-binding="display:isOverdue|not"> <!-- <li class="free"> <div class="name">免邮券</div> <div class="time"><div class="hd">有效期</div><div class="con">2015/07/30</div></div> </li>--> <li sn-repeat="item in data" sn-binding="class:item.VCA_DEDUCT_AMOUNT|cardClass"> <div class="price" sn-binding="html:item.VCA_DEDUCT_AMOUNT|currency"></div> <div class="name" sn-binding="html:item.VCA_NAME"><!--单笔订单满300可用--></div> <div class="time"><div class="hd">有效期</div><div class="con" sn-binding="html:item.CSV_END_DT|date:\'yyyy/MM/dd\'"></div></div> </li> </ul> <ul class="mycard_con" sn-binding="display:isOverdue"> <li class="dis" sn-repeat="item in data1"> <div class="price" sn-binding="html:item.VCA_DEDUCT_AMOUNT|currency"></div> <div class="name" sn-binding="html:item.VCA_NAME"><!--单笔订单满300可用--></div> <div class="time"><div class="hd">有效期</div><div class="con" sn-binding="html:item.CSV_END_DT|date:\'yyyy/MM/dd\'"></div></div> </li> </ul> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/mycard",["images/style.css"],function(e,i,s){var a=(e("$"),e("util")),n=e("activity"),l=e("../widget/loading"),d=e("../core/model"),r=e("../widget/scroll");e("animation");return n.extend({events:{},onCreate:function(){var e=this,i=this.$(".main");r.bind(i),d.Filter.cardClass=function(e){return 10>=e?"price10":50>=e?"price50":""},this.model=new d.ViewModel(this.$el,{back:"/",title:"我的卡券",isOverdue:!1}),e.loading=new l({url:"/api/user/voucher_list",params:{status:0},$el:this.$el,check:!1,checkData:!1,success:function(i){i&&i.data&&0!=i.data.length?i?(e.model.set("data",a.find(i.data,function(e){return!e.IsOverdue})),e.model.set("data1",a.find(i.data,function(e){return e.IsOverdue}))):(e.model.set("data",[]),e.model.set("data1",[])):this.dataNotFound("暂无数据")}}),e.user=a.store("user")},onShow:function(){var e=this;e.user=a.store("user"),e.user?e.loading.setParam({UserID:e.user.ID,Auth:e.user.Auth}).load():e.forward("/login?success="+this.route.url+"&from="+this.route.url)},onDestory:function(){}})});define("template/messages",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main message_center"> <div class="message_card"> <div class="hd"> <h2>文字文字文字文字文字文字</h2> <h3>2015.06.30</h3> </div> <div class="bd">文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字</div> </div> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/messages",["images/style.css"],function(e,i,s){var a=(e("$"),e("util")),n=e("activity"),l=e("../widget/loading"),d=e("../core/model"),r=e("../widget/scroll");e("animation");return n.extend({events:{},onCreate:function(){var e=this,i=this.$(".main");r.bind(i),this.model=new d.ViewModel(this.$el,{back:"/",title:"消息中心"});var s=new l({url:"/api/user/activity_list",$el:this.$el,success:function(i){e.model.set("data",i.data)},append:function(i){e.model.get("data").append(i.data)}});e.user=a.store("user"),e.user&&s.setParam({UserID:e.user.ID,Auth:e.user.Auth})},onShow:function(){var e=this;e.user=a.store("user"),e.user||e.forward("/login?success="+this.route.url+"&from=/")},onDestory:function(){}})});define("template/mypoint",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main mypoint"> <div class="curr">当前积分：<b sn-binding="html:points"></b></div> <div class="notice">*您的积分可以直接抵扣现金使用。<span>（100积分＝1元）</span></div> <div class="hd">积分记录</div> <ul class="mypoint_list"> <li sn-repeat="item in data"> <p class="from" sn-binding="html:item.POT_DESC"></p> <p class="date" sn-binding="html:item.HPT_DT|date:\'yyyy.MM.dd\'"></p> <p class="points" sn-binding="html:item.HPT_POINT_AMOUNT|round|format:\'{0}>0?&quot;+{0}&quot;:&quot;{0}&quot;\'|eval,class:item.HPT_POINT_AMOUNT|lt:0|equal:true:\'minus\':\'\'"></p> </li> </ul> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/mypoint",["images/style.css"],function(e,i,s){var a=(e("$"),e("util")),n=e("activity"),l=e("../widget/loading"),d=e("../core/model"),r=e("../widget/scroll");e("animation");return n.extend({events:{},onCreate:function(){var i=this.$(".main");r.bind(i),this.model=new d.ViewModel(this.$el,{back:"/",title:"我的积分"})},onShow:function(){var e=this,e=this,i=a.store("user");i?(e.user=i,this.loading=new l({url:"/api/user/get_points",check:!1,checkData:!1,params:{UserID:i.ID,Auth:i.Auth},$el:this.$el,success:function(i){e.model.set(i)}}),this.loading.load()):this.forward("/login")},onDestory:function(){}})});define("template/myorder",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main myorder"> <ul class="hd"> <li class="curr" sn-on="tap:select:0">全部</li> <li sn-on="tap:select:1">待付款</li> <li sn-on="tap:select:2">待发货</li> <li sn-on="tap:select:3">配送中</li> <li sn-on="tap:select:4">已完成</li> </ul> <ul class="con"> <li sn-repeat="item in data"> <div class="hd"><b class="from" sn-binding="html:item.PTY_DESC"></b><span class="status" sn-binding="html:item.PUS_DESC"></span></div> <div class="bd" sn-repeat="prd in item.Children"> <img sn-binding="src:prd.WPP_LIST_PIC" /> <div class="con"> <h2 sn-binding="html:prd.PRD_NAME"></h2> <h3>颜色：<span sn-binding="html:prd.PRD_COLOR"></span></h3> <h4>尺寸：<span sn-binding="html:prd.PRD_SPEC"></span></h4> </div> <p class="priceinfo"> <span class="price" sn-binding="html:prd.PRD_MEMBER_PRICE|currency:\'￥\'"></span> <span class="qty" sn-binding="html:prd.LPK_QTY|format:\'x{0}\'"></span> </p> </div> <div class="ft"> 总价：<span sn-binding="html:item.PUR_AMOUNT|currency:\'￥\'"></span> <b class="btn_sml" sn-binding="display:item.XPU_EXPRESS_CODE|equal:null|not">查看物流</b> </div> </li> </ul> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/myorder",["images/style.css"],function(i,e,s){var t=i("$"),a=i("util"),n=i("activity"),l=i("../widget/loading"),d=i("../core/model"),r=i("../widget/scroll");i("animation");return n.extend({events:{},onCreate:function(){var i=this,e=this.$(".main");r.bind(e),this.model=new d.ViewModel(this.$el,{back:"/",title:"我买到的",select:function(e,s){t(e.currentTarget).hasClass("curr")||(t(e.currentTarget).addClass("curr").siblings(".curr").removeClass("curr"),i.loading.setParam(0==s?{status:0,payStatus:0}:1==s?{status:0,payStatus:3}:2==s?{status:18,payStatus:0}:3==s?{status:19,payStatus:0}:{status:20,payStatus:0}).reload())}}),i.loading=new l({url:"/api/order/list",$el:this.$el,checkData:!1,success:function(e){e.data&&0!=e.data.length||this.dataNotFound(e),i.model.set("data",e.data)},append:function(e){i.model.get("data").append(e.data)}}),i.user=a.store("user")},onShow:function(){var i=this;i.user=a.store("user"),i.user?i.loading.setParam({UserID:i.user.ID,Auth:i.user.Auth}).load():i.forward("/login?success="+this.route.url+"&from="+this.route.url)},onDestory:function(){}})});define("template/activity",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main destwrap actwrap"> <div class="destimg"> <img sn-binding="src:data.Pic" /> <div class="destfav" sn-binding="html:data.Favorite"></div> <h1 sn-binding="html:data.Name"></h1> </div> <div class="activity_info"> <div class="act_signup"><b class="act_signup_num" sn-binding="html:data.SignUpQty"></b>报名</div> <div class="act_time"><text sn-binding="html:data.StartTime|date:\'yyyy年MM月dd日 hh:mm\'"></text>~<text sn-binding="html:data.FinishTime|date:\'yyyy年MM月dd日 hh:mm\'"></text></div> <div class="act_address" sn-binding="html:data.Address"></div> </div> <div class="destinfo"> <h2>详情</h2> <div class="destcontent" sn-binding="html:data.Content"></div> </div> <div class="destinfo"> <h2><span class="destcomment js_comment">发表评论</span>评论</h2> <div class="destcontent"> <ul class="quan_list"> <li class="quan_item" sn-repeat="item in comments" sn-binding="data-id:item.ID"> <div class="quan_user"> <img sn-binding="src:item.Avatars" /> <div class="bd"> <h2 sn-binding="html:item.NickName|or:item.Mobile"></h2> <div class="time" sn-binding="html:item.CommentTime|date:\'MM-dd hh:ss\'"></div> </div> </div> <div class="quan_con" sn-binding="html:item.Content"></div> </li> </ul> </div> </div> </div> <footer class="signup_bar"> <b class="btn_signup js_submit">我要报名</b> </footer> ';return __},helpers:{}});return T.template=T.html,T});define("views/activity",["images/style.css"],function(i,e,s){var a=(i("$"),i("util")),n=i("activity"),d=i("../widget/loading"),l=i("../core/model"),r=i("../core/promise"),o=i("../widget/scroll");i("animation");return n.extend({events:{"tap .js_submit:not(.disabled)":function(i){this.user?(this.$submit.addClass("disabled"),this.submit.setParam({UserID:this.user.ID,Auth:this.user.Auth}).load()):this.forward("/login?success="+this.route.url+"&from="+this.route.url)},"tap .js_comment":function(){this.forward("/actcomment/"+this.route.data.id)}},onCreate:function(){var i=this;this.promise=new r,this.$main=this.$(".main"),o.bind(this.$main),l.Filter.precent=function(i){return parseFloat(i)+"%"},this.model=new l.ViewModel(this.$el,{title:"活动详情",back:this.route.query.from||"/"}),this.loading=new d({url:"/api/activity/get",params:{id:this.route.data.id},check:!1,checkData:!1,$el:this.$el,$content:this.$main.children(":first-child"),$scroll:this.$main,success:function(e){i.promise.then(function(){i.model.set(e)}),localStorage.setItem("destination",JSON.stringify(e.data))}}),this.loading.load(),this.$submit=this.$el.find(".js_submit"),this.submit=new d({url:"/api/activity/signup",params:{id:this.route.data.id},check:!1,checkData:!1,$el:this.$el,success:function(e){e.success?(sl.tip("报名成功！"),i.model.set("data.SignUpQty",i.model.data.data.SignUpQty+1)):sl.tip(e.msg),i.$submit.removeClass("disabled")}}),this.comments=new d({url:"/api/activity/comment_list",$el:i.$(".quan_list"),success:function(e){i.model.set("comments",e.data)},append:function(e){i.model.get("comments").append(e.data)}}),this.comments.load(),i.onResult("actcomment_success",function(){i.comments.reload()})},onLoad:function(){this.promise.resolve()},onShow:function(){this.user=a.store("user")},onDestory:function(){}})});define("template/register",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div sn-binding="html:title" class="head_title"></div> <div class="head_back" sn-binding="data-back:back"></div> </header> <div class="main"> <div class="login_form"> <ul class="form"> <li><input placeholder="输入手机号" sn-model="mobile" /></li> <li><input placeholder="验证码" sn-model="smsCode" type="text" /> <b class="js_valid btn_middle" sn-binding="html:valid"></b></li> <li><input placeholder="设置密码" sn-model="password" type="password" /></li> <li><input placeholder="再次输入确认密码" sn-model="password1" type="password" /></li> </ul> <div class="login_btn"><b class="btn_large js_bind">确定注册</b> </div> </div> </div> ';return __},helpers:{}});return T.template=T.html,T});define("views/register",["images/style.css"],function(i,e,s){var a=(i("$"),i("util")),n=i("activity"),d=i("../widget/loading"),l=i("../core/model"),r=i("../widget/scroll"),c=(i("animation"),i("util/md5"));return n.extend({events:{"tap .js_bind:not(.disabled)":function(){var i=this.model.data.mobile,e=this.model.data.password,s=this.model.data.password1,t=this.model.data.smsCode;return i&&a.validateMobile(i)?e!=s?void sl.tip("两次密码输入不一致"):t?void this.loading.setParam({mobile:i,password:c.md5(e),smsCode:t}).load():void sl.tip("请输入验证码"):void sl.tip("请输入正确的手机")},"tap .js_valid:not(.disabled)":function(i){var e=this.model.get("mobile");return e&&a.validateMobile(e)?(this.$valid.addClass("disabled"),this.valid.setParam({mobile:this.model.data.mobile}),void this.valid.load()):void sl.tip("请输入正确的手机")}},validTimeout:function(){var i=this,e=localStorage.getItem("valid_time");if(e&&parseInt(e)>60){if(e=Math.round((new Date(parseInt(e)).getTime()-Date.now())/1e3),0>=e)return;i.$valid.addClass("disabled"),setTimeout(function(){0>=e?(i.$valid.removeClass("disabled"),i.model.set("valid","获取验证码"),localStorage.removeItem("valid_time")):(i.model.set("valid",e+"秒"),e--,setTimeout(arguments.callee,1e3))},1e3)}},onCreate:function(){var i=this,e=this.$(".main");r.bind(e),this.model=new l.ViewModel(this.$el,{title:"注册",valid:"获取验证码",back:this.route.query.from||"/login"}),this.loading=new d({url:"/api/user/register",method:"POST",check:!1,checkData:!1,$el:this.$el,success:function(e){e.success?(localStorage.setItem("user",JSON.stringify(e.data)),i.back(i.route.query.success||"/")):sl.tip(e.msg)},error:function(i){sl.tip(i.msg)}}),this.valid=new d({url:"/api/user/send_sms",method:"POST",params:{mobile:i.model.data.mobile},check:!1,checkData:!1,$el:this.$el,success:function(e){e.success?(localStorage.setItem("valid_time",Date.now()+6e4),i.validTimeout()):sl.tip(e.msg)}}),i.$valid=this.$(".js_valid"),i.validTimeout()},onShow:function(){},onDestory:function(){}})});define("template/guide",function(require){var T=(require("util"),{html:function($data){var __="";with($data||{})__+='\ufeff<header> <div class="head_back" sn-binding="data-back:back"></div> <div sn-binding="html:title" class="head_title"></div> </header> <div class="main guide"> <div class="guide_hd"> 恭喜您成为ABS爱彼此家居会员！<br> 我们为您准备了以下惊喜： </div> <div class="guide_bd"> <ul class="hd"> <li></li> <li>免费礼</li> <li>终身<br>免费定制</li> <li>终身<br>免费礼</li> </ul> <ul class="row"> <li> <span>SVIP会员</span> <p>累计金额<br>≥￥50000</p> </li> <li><p>终身<br>免费礼</p></li> <li></li> <li></li> </ul> <ul class="row"> <li> <span>VIP会员</span> <p>￥10000≦<br>累计金额<br>＜￥50000</p> </li> <li><p>12个月<br>免费礼</p></li> <li></li> <li></li> </ul> <ul class="row"> <li> <span>钻石会员</span> <p>￥5000≦<br>累计金额<br>＜￥10000</p> </li> <li><p>12个月<br>免费礼</p></li> <li></li> <li class="none"></li> </ul> <ul class="row"> <li> <span>金卡会员</span> <p>￥1000≦<br>累计金额<br>＜￥5000</p> </li> <li><p>12个月<br>免费礼</p></li> <li></li> <li class="none"></li> </ul> <ul class="row"> <li> <span>银卡会员</span> <p>￥0＜<br>累计金额<br>＜￥1000</p> </li> <li class="none"><p></p></li> <li></li> <li class="none"></li> </ul> <div class="more"> 更多会员权益，请关注ABS官方微信或登录官网www.abs.cn咨询。ABS会员专享权益，最终解释权归上海爱彼此家居用品股份有限公司所有。 </div> </div> </div>';return __},helpers:{}});return T.template=T.html,T});define("views/guide",["images/style.css"],function(i,e,s){var n=(i("$"),i("util"),i("activity")),d=(i("widget/loading"),i("core/model")),r=i("widget/scroll");i("animation");return n.extend({events:{"tap .js_bind:not(.disabled)":function(){}},swipeRightBackAction:"/",onCreate:function(){var e=this.$(".main");r.bind(e),this.model=new d.ViewModel(this.$el,{back:"/",title:"新手指南"})},onShow:function(){},onDestory:function(){}})});