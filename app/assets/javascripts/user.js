var User = function () {
  var show = function () {
    $(".image-link-container").mouseenter(function () {
      $(".photo-upload-link").fadeIn("fast");
      $(".edit-user-link").fadeIn("fast");
    });
    $(".image-link-container").mouseleave(function () {
      $(".photo-upload-link").fadeOut("fast");
      $(".edit-user-link").fadeOut("fast");
    });

    $(".photo-upload-link").on("click", function () {
      $("div.photo-upload-hidden").fadeIn("fast");
    });

    $(".photo-upload-form").on("click", function (event) {
      event.stopPropagation();
    });

    $("div.photo-upload-hidden").on("click", function() {
      $(this).fadeOut("fast");
    });
  };

  return {
    show: show
  }
}();