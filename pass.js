var pass = prompt("What's the magic word?");
function goBack() {
  window.history.back();
}

if (pass == "1596") {
  alert("welcome matthijs!")
} else {
  alert("WRONG!");
  goBack();
}
