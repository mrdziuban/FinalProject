var Topic = function () {
  var editInterval,
      submitUrl,
      topicId,
      currentUserId,
      updateUrl

  var converter = new Attacklab.showdown.converter();

  var show = function (mySubmitUrl, myTopicId, myCurrentUserId, myUpdateUrl) {
    submitUrl = mySubmitUrl;
    topicId = myTopicId;
    currentUserId = myCurrentUserId;
    updateUrl = myUpdateUrl;

    var description = $("div.description-container").text();
    $("div.description-container").html(converter.makeHtml(description));

    $(".comment-text").each(function (i, el) {
      var text = $(el).text();
      $(el).html(converter.makeHtml(text));
    });

    var topic = $(".topic-container");

    topic.on("click", ".edit-topic-button", function () {
      $("div.edit-topic-hidden").fadeIn("fast");

      editInterval = setInterval(function () {
        if ($(".title-field").val() === "") {
          $(".update-topic").attr("disabled", true);
        }
        else {
          $(".update-topic").attr("disabled", false);
        }
      }, 100);
    });

    $(".edit-topic").on("click", function (event) {
      event.stopPropagation();
    });

    $("div.edit-topic-hidden").on("click", function () {
      $(this).fadeOut("fast");
    });

    $(".update-topic").on("click", updateTopic);

    topic.on("click", ".comments-header", function () {
      $(".post-comment").slideToggle("fast");
    });

    topic.on("click", ".help-link", function () {
      $(".help-image").fadeToggle();
    })

    topic.on("click", ".comment-reply", function () {
      $(this).siblings(".reply-comment").slideToggle("fast");
    });

    topic.on("click", ".comment-edit", function () {
      $(this).siblings(".edit-comment").slideToggle("fast");
    });

    topic.on("click", ".submit-comment-button", submitComment);
    topic.on("click", ".reply-comment-button", replyComment);
    topic.on("click", ".update-comment-button", updateComment);
    topic.on("click", ".comment-delete", deleteComment);

    topic.on("click", ".more-link", function (event) {
      event.preventDefault();
      var a = $(this);

      $.get(a.attr("href"), function (data) {
        var tmp = $(".comments-list > li").length
        $(".comments-list").append(data)
        var tmp2 = $(".comments-list > li").length
        if (tmp2 - tmp < 100) {
          a.remove();
        }
      });
    });
  };

  var updateTopic = function (event) {
    event.preventDefault();
    var that = this;
    var formData = $(that.form).serialize();

    $.ajax({
      url: that.form.action,
      type: "PUT",
      data: formData,
      success: function (data) {
        clearInterval(editInterval);
        $("div.edit-topic-hidden").fadeOut("fast");
        $(that.form).each(function () {this.reset()});
        $(".topic-header-container").html(data);
        var d = $("div.description-container").text();
        $("div.description-container").html(converter.makeHtml(d));
      }
    });
  };

  var submitComment = function (event) {
    var data = {
      comment: {
        text: $(".comment-input").val(),
        topic_id: topicId,
        user_id: currentUserId
      }
    };
    
    $.ajax({
      url: submitUrl,
      type: "POST",
      data: data,
      success: function (data) {
        $(".comment-input").val("");
        $(".post-comment").slideToggle();
        $(".comments-list").prepend(data);
        var text = $(".comment-text").first().text();
        $(".comment-text").first().html(converter.makeHtml(text));
      },
      error: function () {
        $(".comment-input").val("You must enter comment text");
      }
    });
  };

  var replyComment = function () {
    var commentId = $(this).closest("section").siblings(".comment-text").attr("id");
    var replyComment = $(this).closest("section");
    var commentInput = $(this).siblings(".reply-comment-input");
    var ul = replyComment.siblings("ul");

    var data = {
      comment: {
        text: commentInput.val(),
        topic_id: topicId,
        user_id: currentUserId,
        parent_comment_id: commentId
      }
    };
    
    $.ajax({
      url: submitUrl,
      type: "POST",
      data: data,
      success: function (data) {
        commentInput.val("");
        replyComment.slideToggle();
        ul.prepend(data);
        ul.find(".comment-text").each(function (i, el) {
          var text = $(el).text();
          $(el).html(converter.makeHtml(text));
        });
      },
      error: function () {
        commentInput.val("You must enter comment text");
      }
    });
  };

  var updateComment = function () {
    var that = this;
    var commentId = $(that).closest("section").siblings(".comment-text").attr("id");
    var editComment = $(that).closest("section");
    var commentInput = $(that).siblings(".edit-comment-input");
    var li = $(that).closest("li");

    var data = {
      comment: {
        text: $(that).siblings(".edit-comment-input").val()
      }
    };
    
    $.ajax({
      url: updateUrl + commentId,
      type: "PUT",
      data: data,
      success: function (data) {
        editComment.slideToggle();
        li.html(data);
        var text = $(document.getElementById(commentId)).text();
        $(document.getElementById(commentId)).html(converter.makeHtml(text));
      },
      error: function () {
        commentInput.val("You must enter comment text");
      }
    });
  };

  var deleteComment = function () {
    var that = this;
    var commentId = $(that).siblings(".comment-text").attr("id");
    
    $.ajax({
      url: "/comments/" + commentId,
      type: "DELETE",
      success: function () {
        if ($(that).closest("li").siblings("li").length === 0) {
          $(that).closest("ul").fadeOut("fast");
          $(that).closest("ul").remove();
        }
        else {
          $(that).closest("li").fadeOut("fast");
          $(that).closest("li").remove();
        }
      }
    });
  };

  return {
    show: show
  }
}();