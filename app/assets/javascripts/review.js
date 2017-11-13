App.Review = function() {
  $('.js-review-form textarea').each(function() {
    CKEDITOR.replace(this);
  });

  $('a.js-new-review').on('click', (e) => {
    e.preventDefault();
    $(".js-review-form:not([class*='hidden'])").addClass('hidden');
    $('.js-new-review .js-review-form').toggleClass('hidden');
  });

  $(document).on('click', 'a.js-edit-review', (e) => {
    e.preventDefault();
    $(".js-review-form:not([class*='hidden'])").addClass('hidden');
    $(e.target).siblings('.js-review-form').toggleClass('hidden');
  });

  $(document).on('click', '.js-review-form .js-cancel', (e) => {
    e.preventDefault();
    $(e.target).closest('.js-review-form').toggleClass('hidden');
  });
}

App.Review.addReview = (review) => {
  $('.js-new-review .js-review-form').toggleClass('hidden');
  var $review = $(review);
  $('.js-review-list').append($review);
  CKEDITOR.replace($review.find('textarea')[0]);
  new App.Rate();
};

App.Review.addErrors = (errors) => {
  $('.js-review-errors').html(errors);
};

App.Review.removeReview = (reviewId) => {
  $('.js-review[data-id=' + reviewId + ']').remove();
}

App.Review.addErrorsToReview = (reviewId, errors) => {
  $('.js-review[data-id=' + reviewId + '] .js-review-errors').html(errors);
};

App.Review.updateReview = (reviewId, review) => {
  $('.js-review[data-id=' + reviewId + ']').replaceWith(review);
  new App.Rate();
}

$(document).on('turbolinks:load', () => {
  var page = $('body').data('page');
  if (page !== 'tours:show') return;
  new App.Review();
});
