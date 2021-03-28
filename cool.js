function checkImage() {
    var d = new Date();
      var n = d.getHours();
      
      if (n > 19 || n < 6)
        $("body").css("background", "url('avond.jpg')");
      else if (n > 13 && n < 19)
        $("body").css("background", "url('middag.jpg')");
      else
         $("body").css("background-image", "url('https://www.tsbouwvastgoed.nl/wp-content/uploads/2020/07/chuttersnap-TSgwbumanuE-unsplash-2000x1050.jpg')");
}
function checkTime(i) {
    if (i < 10) {
      i = "0" + i;
    }
    return i;
  }
  checkImage()
  function startTime() {
    var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();
    // add a zero in front of numbers<10
    m = checkTime(m);
    s = checkTime(s);
    document.getElementById('time').innerHTML = h + ":" + m + ":" + s;
    t = setTimeout(function() {
      startTime()
      checkImage()
    }, 500);
  }
  startTime();
  console.log("lol");