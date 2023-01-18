$(document).ready(function(){
$(".text").fadeIn("slow");
$(".a").click(function(){
    $(".text").fadeOut(300);
    $(".about").delay(300).fadeIn();
  });
  $(".a2").click(function(){
    $(".about").fadeOut(300);
    $(".text").delay(300).fadeIn();
  });
  let url = "https://ci.appveyor.com/api/projects/matthijs12310/fdhsdfh";
  var xhr = new XMLHttpRequest();
  xhr.open("GET", url);
  xhr.setRequestHeader("Authorization", "Bearer n8j33g8ervqeoaptt4ii");
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      console.log(xhr.status);
      json = JSON.parse(xhr.responseText)
      console.log(json)
      if (json.build.status == "cancelled") {
        console.log("cancelled");
        document.getElementById("buildstatus").innerHTML = "RDP is not running yet"
        return
      }
      else if (json.build.status == "failed") {
        if (json.build.status == "failed")
        document.getElementById("buildstatus").innerHTML = "RDP is not running yet"
        return
      }
      else{
        document.getElementById("rdpp").style.display = "none"
      }
      let jobId = json.build.jobs[0].jobId
      console.log(jobId)
      url = "https://ci.appveyor.com/api/buildjobs/" + jobId + "/log"
      var client = new XMLHttpRequest();
client.open('GET', url);
client.onreadystatechange = function() {
  let logs = client.responseText.split(" ")
  let logss = logs[68]
  console.log(logss)
  const searchTerm = "["
  const hoerending = logss.indexOf(searchTerm)
  logss = logss.slice(0, hoerending)
  document.getElementById("buildstatus").innerHTML = logss
}
client.send();

   }};
   xhr.send();
});

var makeItRain = function() {
    //clear out everything
    $('.rain').empty();
  
    var increment = 0;
    var drops = "";
    var backDrops = "";
  
    while (increment < 100) {
      //couple random numbers to use for various randomizations
      //random number between 98 and 1
      var randoHundo = (Math.floor(Math.random() * (98 - 1 + 1) + 1));
      //random number between 5 and 2
      var randoFiver = (Math.floor(Math.random() * (5 - 2 + 1) + 2));
      //increment
      increment += randoFiver;
      //add in a new raindrop with various randomizations to certain CSS properties
      drops += '<div class="drop" style="left: ' + increment + '%; bottom: ' + (randoFiver + randoFiver - 1 + 100) + '%; animation-delay: 0.' + randoHundo + 's; animation-duration: 0.5' + randoHundo + 's;"><div class="stem" style="animation-delay: 0.' + randoHundo + 's; animation-duration: 0.5' + randoHundo + 's;"></div><div class="splat" style="animation-delay: 0.' + randoHundo + 's; animation-duration: 0.5' + randoHundo + 's;"></div></div>';
      backDrops += '<div class="drop" style="right: ' + increment + '%; bottom: ' + (randoFiver + randoFiver - 1 + 100) + '%; animation-delay: 0.' + randoHundo + 's; animation-duration: 0.5' + randoHundo + 's;"><div class="stem" style="animation-delay: 0.' + randoHundo + 's; animation-duration: 0.5' + randoHundo + 's;"></div><div class="splat" style="animation-delay: 0.' + randoHundo + 's; animation-duration: 0.5' + randoHundo + 's;"></div></div>';
    }
  
    $('.rain.front-row').append(drops);
    $('.rain.back-row').append(backDrops);
  }
  
  $('.splat-toggle.toggle').on('click', function() {
    $('body').toggleClass('splat-toggle');
    $('.splat-toggle.toggle').toggleClass('active');
    makeItRain();
  });
  
  $('.back-row-toggle.toggle').on('click', function() {
    $('body').toggleClass('back-row-toggle');
    $('.back-row-toggle.toggle').toggleClass('active');
    makeItRain();
  });
  
  $('.single-toggle.toggle').on('click', function() {
    $('body').toggleClass('single-toggle');
    $('.single-toggle.toggle').toggleClass('active');
    makeItRain();
  });
  
  makeItRain();


  function StartBuild() {
    $(".startbut").hide();
    fetch('https://ci.appveyor.com/api/projects/matthijs12310/fdhsdfh', {
      headers: {
        'Authorization' : 'Bearer n8j33g8ervqeoaptt4ii'
      }
    })
    .then((response) => response.json())
    .then((data) => {
      console.log(data.build.status)
      if ((data.build.status == "cancelled") || (data.build.status == "failed")) {
        document.getElementById("buildstatus").innerHTML = "Starting..."
        var url = "https://ci.appveyor.com/api/builds";
        var xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader("Authorization", "Bearer n8j33g8ervqeoaptt4ii");
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.onreadystatechange = function () {
       if (xhr.readyState === 4) {
          console.log(xhr.status);
          console.log(xhr.responseText);
       }};
    var data = `{
        "accountName": "matthijs12310",
        "projectSlug": "fdhsdfh",
        "branch": "master"
    }`;
    xhr.send(data);
    setTimeout(function(){
      window.location.reload();
   }, 22000);
      }
      else {
        $(".startbut").fadeIn(300);
        return
      }
    });
  }