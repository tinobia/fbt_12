function addImage() {
  var association = $(this).data("association");
  var content = $(this).data("content");
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  var regexp2 = new RegExp('\"', "g");
  $("." + association + "-list").append(content.replace(regexp, new_id));
}

function removeImage() {
  $(this).prev("input[type=file]").first().val("");
  $(this).prev("input[type=hidden]").first().val("1");
  $(this).closest(".fields").first().hide();
}

document.addEventListener("turbolinks:load", function () {
  $("body").on("click", ".btn-add-more", addImage);
  $("body").on("click", ".btn-remove", removeImage);
  $("#thumbnail_id").imagepicker();
});
