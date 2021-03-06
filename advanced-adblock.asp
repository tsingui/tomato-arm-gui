<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
Tomato GUI
Copyright (C) 2007-2011 Shibby
http://openlinksys.info
For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] Advanced: Adblock</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='color.css'>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->
<style type='text/css'>
#adblockg-grid {
width: 100%;
}
#adblockg-grid .co1 {
width: 5%;
text-align: center;
}
#adblockg-grid .co2 {
width: 70%;
}
#adblockg-grid .co3 {
width: 25%;
}
textarea {
width: 98%;
height: 15em;
}
</style>

<script type='text/javascript' src='debug.js'></script>
<script type='text/javascript'>
//	<% nvram("adblock_enable,adblock_blacklist,adblock_blacklist_custom,adblock_whitelist,dnsmasq_debug"); %>
var adblockg = new TomatoGrid();
adblockg.exist = function(f, v)
{
var data = this.getAllData();
for (var i = 0; i < data.length; ++i) {
if (data[i][f] == v) return true;
}
return false;
}
adblockg.dataToView = function(data) {
return [(data[0] != '0') ? '启用' : '', data[1], data[2]];
}
adblockg.fieldValuesToData = function(row) {
var f = fields.getAll(row);
return [f[0].checked ? 1 : 0, f[1].value, f[2].value];
}
adblockg.verifyFields = function(row, quiet)
{
var ok = 1;
return ok;
}
function verifyFields(focused, quiet)
{
var ok = 1;
return ok;
}
adblockg.resetNewEditor = function() {
var f;
f = fields.getAll(this.newEditor);
ferror.clearAll(f);
f[0].checked = 1;
f[1].value = '';
f[2].value = '';
}
adblockg.setup = function()
{
this.init('adblockg-grid', '', 50, [
{ type: 'checkbox' },
{ type: 'text', maxlen: 90 },
{ type: 'text', maxlen: 40 }
]);
this.headerSet(['启用', '黑名单 URL', '描述']);
var s = nvram.adblock_blacklist.split('>');
for (var i = 0; i < s.length; ++i) {
var t = s[i].split('<');
if (t.length == 3) this.insertData(-1, t);
}
this.showNewEditor();
this.resetNewEditor();
}
function save()
{
var data = adblockg.getAllData();
var blacklist = '';
for (var i = 0; i < data.length; ++i) {
blacklist += data[i].join('<') + '>';
}
var fom = E('_fom');
fom.adblock_enable.value = E('_f_adblock_enable').checked ? 1 : 0;
fom.dnsmasq_debug.value = E('_f_dnsmasq_debug').checked ? 1 : 0;
fom.adblock_blacklist.value = blacklist;
form.submit(fom, 1);
}
function init()
{
adblockg.recolor();
}
</script>
</head>
<body onload='init()'>
<form id='_fom' method='post' action='tomato.cgi'>
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
<div class='title'>Tomato</div>
	<div class='version'>Version <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>

<!-- / / / -->

<input type='hidden' name='_nextpage' value='advanced-adblock.asp'>
<input type='hidden' name='_service' value='adblock-restart'>
<input type='hidden' name='adblock_enable'>
<input type='hidden' name='dnsmasq_debug'>
<input type='hidden' name='adblock_blacklist'>
<div class='section-title'>Adblock 配置</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
{ title: '启用', name: 'f_adblock_enable', type: 'checkbox', value: nvram.adblock_enable != '0' },
{ title: '调试模式', indent: 2, name: 'f_dnsmasq_debug', type: 'checkbox', value: nvram.dnsmasq_debug == '1' }
]);
</script>
</div>
<div class='section-title'>黑名单 URL</div>
<div class='section'>
<table class='tomato-grid' cellspacing=1 id='adblockg-grid'></table>
<script type='text/javascript'>adblockg.setup();</script>
</div>
<div class='section-title'>自定义黑名单</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
{ title: '已加入黑名单的域名', name: 'adblock_blacklist_custom', type: 'textarea', value: nvram.adblock_blacklist_custom }
]);
</script>
</div>
<div class='section-title'>白名单</div>
<div class='section'>
<script type='text/javascript'>
createFieldTable('', [
{ title: '已加入白名单的域名', name: 'adblock_whitelist', type: 'textarea', value: nvram.adblock_whitelist }
]);
</script>
</div>
<div class='section-title'>Notes</div>
<div class='section'>
<ul>
	<li><b>Adblock</b> - 自动更新将在每天凌晨 2:00-2.59 AM 启动
<li><b>调试模式</b> - 所有对 dnsmasq 的查询将被记录到系统日志
<li><b>调试模式</b> - 正确的文件格式: 0.0.0.0 domain.com 或 127.0.0.1 domain.com, 每行一个域名
<li><b>黑名单自定义</b> - 可选, 空格分隔: domain1.com domain2.com domain3.com
<li><b>白名单</b> - 可选, 空格分隔: domain1.com domain2.com domain3.com
</ul>
</div>

<!-- / / / -->

</td></tr>
<tr><td id='footer' colspan=2>
<span id='footer-msg'></span>
<input type='button' value='保存设置' id='save-button' onclick='save()'>
<input type='button' value='取消设置' id='cancel-button' onclick='reloadPage();'>
</td></tr>
</table>
</form>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>
