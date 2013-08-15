var Player = function () {
  var playerId;
  var myUrl;

  var index = function () {
    var players = $(".players-container");

    players.on("click", ".paginator a", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        players.html(data);
      });
    });

    players.on("click", "thead a", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        players.html(data);
      });
    });
  };

  var show = function (myPlayerId, myUrl) {
    playerId = myPlayerId;
    url = myUrl;

    $("input[type=submit]").on("click", togglePlayerFavorite)
  };

  var togglePlayerFavorite = function () {
    if (event.currentTarget.className === "favorite") {
      var buttonClicked = "favorite"
      var meth = "POST"
    }
    else {
      var buttonClicked = "unfavorite"
      var meth = "DELETE"
    }

    var params = {
      id: playerId,
      type: "Player"
    };

    $.ajax({
      url: url,
      type: meth,
      data: params,
      success: function() {
        $(".favorite-buttons").toggleClass("favorited", buttonClicked == "favorite");
      },
      error: function() {
        alert("Request failed");
        console.log("error");
      }
    });
  }

  return {
    index: index,
    show: show
  }
}();