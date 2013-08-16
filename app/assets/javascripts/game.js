var Game = function () {
  var index = function () {
    var games = $(".games-container");

    games.on("click", ".paginator a", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        games.html(data);
      });
    });

    games.on("click", "thead a", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        games.html(data);
      });
    });
    
    games.on("click", ".season-selector a", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        games.html(data);
      })
    });
  };

  return {
    index: index
  }
}();