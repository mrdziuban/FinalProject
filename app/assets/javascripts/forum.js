var Forum = function () {
  var show = function () {
    var converter = new Attacklab.showdown.converter();

    $("div.description-hidden").each(function (i, el) {
      var description = $(el).text();
      $(el).html(converter.makeHtml(description));
    });

    $(".forum-container").on("click", ".create-topic-link", function () {
      $("div.new-topic-hidden").fadeIn("fast");

      setInterval(function () {
        if ($(".title-field").val() === "") {
          $(".create-topic").attr("disabled", true);
        }
        else {
          $(".create-topic").attr("disabled", false);
        }
      }, 100);
    });

    $(".new-topic").on("click", function (event) {
      event.stopPropagation();
    });

    $("div.new-topic-hidden").on("click", function () {
      $(this).fadeOut("fast");
    });

    var topics = $(".forum-container");

    topics.on("click", "div.description-hidden, li a", function (event) {
      event.stopPropagation();
    });

    topics.on("click", "li", function () {
      $(this).find("div.description-hidden").slideToggle("fast");
      if ($(this).find(".circle-plus").attr("src") == "/assets/circle_plus.png" || $(this).find(".circle-plus").attr("src") == "/assets/circle_plus-f0ee6d85e489c5b6de90ded216286da9.png") {
        $(this).find(".circle-plus").attr("src", "/assets/circle_minus.png");
      }
      else {
        $(this).find(".circle-plus").attr("src", "/assets/circle_plus.png");
      }
    });

    topics.on("click", ".more-link", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        var tmp = $(".forum-container li").length;
        $(".topics-list").append(data);
        var tmp2 = $(".forum-container li").length;
        $("div.description-hidden").each(function (i, el) {
          var description = $(el).text();
          $(el).html(converter.makeHtml(description));
        });
        if (tmp2 - tmp < 20) {
          a.remove();
        }
      });
    });
  };

  return {
    show: show
  }
}();