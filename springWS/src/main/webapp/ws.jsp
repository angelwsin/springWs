<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="js/jquery-2.1.4.js"></script>
<title>Insert title here</title>
<table>
  <tr>
    <td>Message</td>
    <td><input type="text" id="message"></td>
  </tr>
  <tr>
    <td>Name</td>
    <td><input type="text" id="othername"></td>
  </tr>
  <tr>
    <td><input id="sendbutton" type="button" value="send" onClick="click"  disabled="true">
      </input></td>
  </tr>
</table>
</head>
<body>
       
</body>
<script type="text/javascript">
var username = window.prompt("输入你的名字:");

document.write("Welcome<p id=\"username\">"+username+"</p>");

if (!window.WebSocket && window.MozWebSocket)
    window.WebSocket=window.MozWebSocket;
if (!window.WebSocket)
    alert("No Support ");
var ws;

$(document).ready(function(){
   
     $("#sendbutton").attr("disabled", false);
     $("#sendbutton").click(sendMessage);

    startWebSocket();
})

function sendMessage()
{
    var othername=$("#othername").val();
    var msg="MSG\t"+username+"_"+othername+"_"+$("#message").val();
    send(msg);
}
function send(data)
{
    console.log("Send:"+data);
    ws.send(data);
}
function startWebSocket()
{   
    ws = new WebSocket("ws://" + location.host + "/springWS/ws/chat/"+username);
    ws.onopen = function(){
        console.log("success open");
        $("#sendbutton").attr("disabled", false);
    };
     ws.onmessage = function(event)
     {
         console.log("RECEIVE:"+event.data);
         handleData(event.data);
     };
      ws.onclose = function(event) {
    console.log("Client notified socket has closed",event);
  };
 
}

function handleData(data)
{
    var vals=data.split("\t");
    var msgType=vals[0];
    switch(msgType)
    {
    case "NAME":
        var msg=vals[1];
        var mes="NAME"+"\t"+msg+"_"+ username;
        send(mes);
        break;
    case "MSG":
        var val2s=vals[1].split("_");
        var from=val2s[0];
        var message=val2s[2];
        alert(from+":"+message);
        break;
    default:
        break;
           
    }
}
 </script>
</html>