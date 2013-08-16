var Navbar = function () {
  var url;

  var init = function (names, myUrl) {
    url = myUrl;

    $(".stats").mouseenter(function () {
      $(".dropdown").slideDown("fast");
    });
    $(".stats").mouseleave(function () {
      $(".dropdown").slideUp("fast");
    });

    $(".players-option").mouseenter(function () {
      $(".players-sidedrop").animate({width: "toggle"}, "fast");
    });
    $(".players-option").mouseleave(function () {
      $(".players-sidedrop").animate({width: "toggle"}, "fast");
    });

    $(".search-bar").typeahead({
      name: "names",
      local: names
    });

    $("span.navbar-float-right > li input").keypress(search);

    $(".search-results").on("click", function (event) {
      event.stopPropagation();
    });

    $("div.search-results-hidden").on("click", function () {
      $(this).fadeOut("fast");
    });
  };

  var search = function (event) {
    if (event.which === 13) {
      var that = this;
      var data = {query: $(this).val()};

      $.ajax({
        url: url,
        type: "POST",
        data: data,
        success: function (data) {
          $(".search-results").html(data);
          $(that).blur();
          $(".search-results-hidden").fadeIn("fast");
        },
        error: function () {
          console.log("error");
        }
      });
    }
  };

  return {
    init: init
  }
}();