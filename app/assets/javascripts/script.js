//TABS
document.addEventListener("turbolinks:load", function () {
  $(".tab-content").hide().first().show();
  $(".inner-nav li:first").addClass("active");

  $(".inner-nav a").on("click", function (e) {
    e.preventDefault();
    $(this).closest("li").addClass("active").siblings().removeClass("active");
    $($(this).attr("href")).show().siblings(".tab-content").hide();
  });
});
