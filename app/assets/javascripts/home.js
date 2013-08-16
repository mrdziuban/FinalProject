var Home = function () {
  var init = function () {
    var positions = [
  [0, -234], [0, -468], [0, -702], [0, -936], [0, -1170], [0, -1404],
  [-416, -234], [-416, -468], [-416, -702], [-416, -936], [-416, -1170], [-416, -1404],
  [-832, -234], [-832, -468], [-832, -702], [-832, -936], [-832, -1170], [-832, -1404],
  [-1248, -234], [-1248, -468], [-1248, -702], [-1248, -936], [-1248, -1170], [-1248, -1404],
  [-1664, -234], [-1664, -468], [-1664, -702], [-1664, -936], [-1664, -1170], [-1664, -1404]]

    $("a.teams-sprite").mouseenter(function () {
      var i = Math.floor(Math.random() * positions.length)
      pos = positions[i]
      $(this).css("background-position", pos[0] + "px " + pos[1] + "px")
    });

    $("a.teams-sprite").mouseleave(function () {
      $(this).css("background-position", "0 0")
    });
  };

  return {
    init: init
  }
}();