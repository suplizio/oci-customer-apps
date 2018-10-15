var request = new XMLHttpRequest();
request.open("GET", document.location, true);
request.onreadystatechange = function() {
  if(this.readyState == this.HEADERS_RECEIVED) {

    var backendIP = request.getResponseHeader("backend-ip");
    var hostIP = request.getResponseHeader("host-ip");

    document.getElementById("backend-ip").innerHTML = backendIP;
    document.getElementById("host-ip").innerHTML = hostIP;
    var headers = request.getAllResponseHeaders();
    var arr = headers.trim().split(/[\r\n]+/);
    var headerMap = {};
    arr.forEach(function (line) {
      console.log("line -> " + line);
      var parts = line.split(': ');
      var header = parts.shift();
      var value = parts.join(': ');
      headerMap[header] = value;
    });
  }
}
request.send(null);
