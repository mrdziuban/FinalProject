var Goalie = function () {
  var goalieId;
  var url;

  var index = function () {
    var goalies = $(".goalies-container");

    goalies.on("click", ".paginator a", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        goalies.html(data);
      });
    });

    goalies.on("click", "thead a", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        goalies.html(data);
      });
    });
  };

  var show = function (myGoalieId, myUrl) {
    goalieId = myGoalieId;
    url = myUrl;
    $("input[type=submit]").on("click", toggleGoalieFavorite);
  };

  var toggleGoalieFavorite = function (event) {
    if (event.currentTarget.className === "favorite") {
      var buttonClicked = "favorite"
      var meth = "POST"
    }
    else {
      var buttonClicked = "unfavorite"
      var meth = "DELETE"
    }

    var params = {
      id: goalieId,
      type: "Goalie"
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