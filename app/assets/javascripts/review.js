App.Review = function() {
  $('.js-review-form textarea').each(function() {
    CKEDITOR.replace(this);
  });

  $(document).on('click', 'a.js-new-review', (e) => {
    e.preventDefault();
    $('.js-form:not([class*="hide"])').addClass('hide');
    $('.js-new-review .js-review-form').toggleClass('hide');
  });

  $(document).on('click', 'a.js-edit-review', (e) => {
    e.preventDefault();
    $('.js-form:not([class*="hide"])').addClass('hide');
    $(e.target).parent().siblings('.js-review-form').toggleClass('hide');
  });

  $(document).on('click', '.js-review-form .js-cancel', (e) => {
    e.preventDefault();
    $(e.target).closest('.js-review-form').toggleClass('hide');
  });
};

App.Review.addReview = (review) => {
  $('.js-new-review .js-review-form').toggleClass('hide');
  var $review = $(review);
  $('.js-review-list').append($review);
  $review.find('textarea').each(function() {
    CKEDITOR.replace(this);
  });
  new App.Rate();
};

App.Review.addErrors = (errors) => {
  $('.js-review-errors').html(errors);
};

App.Review.removeReview = (reviewId) => {
  $('.js-review[data-id=' + reviewId + ']').remove();
};

App.Review.addErrorsToReview = (reviewId, errors) => {
  $('.js-review[data-id=' + reviewId + '] .js-review-errors').html(errors);
};

App.Review.updateReview = (reviewId, review) => {
  $('.js-review[data-id=' + reviewId + ']').replaceWith(review);
  new App.Rate();
};

App.Review.updateReviews = (reviews) => {
  $('.js-reviews').replaceWith(reviews);
  new App.Rate();
}

$(document).on('turbolinks:load', () => {
  var page = $('body').data('page');
  if (page !== 'tours:show' && page !== 'users:show') return;
  new App.Review();
});
