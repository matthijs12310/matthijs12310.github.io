var d = new Date();
      var n = d.getHours();
      
      if (n > 19 || n < 6)
        $("body").css("background", "url('night.jpg')");
      else if (n > 16 && n < 19)
        $("body").css("background", "url('sunset.jpg')");
      else
         document.getElementById("Text1").innerHTML = "Het is " + n + " uur";
        $("body").css("background", "url('https://www.almanac.com/sites/default/files/styles/primary_image_in_article/public/image_nodes/summer-sunset.jpg')");