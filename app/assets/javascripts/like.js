App.Like = function() {};

App.Like.updateLike = (reviewId, likeCount) => {
  $('.js-review[data-id="' + reviewId + '"] .js-like-count').html(
    likeCount);
};

App.Like.updateLikeButton = (reviewId, button) => {
  $('.js-review[data-id="' + reviewId + '"] .js-like-button').html(
    button);
};
