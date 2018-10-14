/*
var req = new XMLHttpRequest();
req.open('GET', document.location, false);
req.send(null);
var headers = req.getAllResponseHeaders().toLowerCase();
alert(headers);
 */
var xhr = new XMLHttpRequest();
xhr.open("GET", document.location, true);
xhr.onload = function (e) {
  if (xhr.readyState === 4) {
    if (xhr.status === 200) {
      console.log(xhr.responseText);
      console.log(xhr.getAllResponseHeaders().toLowerCase())
      console.log("server -->  " + xhr.getResponseHeader("server"))
      // alert(xhr.getAllResponseHeaders().toLowerCase())
      document.getElementById("server_id").innerHTML = xhr.getResponseHeader("server");

    } else {
      console.error(xhr.statusText);
    }
  }
};
xhr.onerror = function (e) {
  console.error(xhr.statusText);
};
xhr.send(null);