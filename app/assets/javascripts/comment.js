App.Comment = function() {
  $('.js-comment-form textarea').each(function() {
    CKEDITOR.replace(this);
  });

  $(document).on('click', '.toggle-comments', (e) => {
    e.preventDefault();
    $(e.target).next('.comments').toggleClass('hide');
  });

  $(document).on('click', '.js-comment-button', (e) => {
    e.preventDefault();
    $('.js-comment-form:not([class*="hide"])').toggleClass('hide');
    $(e.target).siblings('.js-comment-form').toggleClass('hide');
  });

  $(document).on('click', '.js-comment-cancel', (e) => {
    $(e.target).closest('.js-comment-form').toggleClass('hide');
  });
};

App.Comment.addComment = (commentableType, commentableId, comment) => {
  var $commentable = $('.js-' + commentableType + '[data-id="' + commentableId + '"]');
  var $comment = $(comment);
  $commentable.find('ul.comments').append($comment);
  $comment.find('textarea').each(function() {
    CKEDITOR.replace(this);
  });
  $commentable.find('.js-comment-form:not([class*="hide"])').toggleClass('hide');
  $commentable.find('.comments[class*="hide"]').toggleClass('hide');
};

App.Comment.updateComments = (commentableType, commentableId, comments) => {
  var $commentable = $('.js-' + commentableType + '[data-id="' + commentableId + '"]');
  var $comments = $(comments);
  $commentable.find('ul.comments').replaceWith($comments);
  $comments.find('textarea').each(function() {
    CKEDITOR.replace(this);
  });
  $commentable.find('.js-comment-form:not([class*="hide"])').toggleClass('hide');
  $commentable.find('.comments[class*="hide"]').toggleClass('hide');
};

App.Comment.addErrors = (commentableType, commentableId, errors) => {
  var $commentable = $('.js-' + commentableType + '[data-id="' + commentableId + '"]');
  $commentable.find('.js-form-errors').html(errors);
};

$(document).on('turbolinks:load', () => {
  var page = $('body').data('page');
  if (page !== 'tours:show') return;
  new App.Comment();
});
