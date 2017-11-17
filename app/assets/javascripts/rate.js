App.Rate = function() {
  $('.review-rate').each((index, rate) => {
    var readOnly = $(rate).data('read-only') || false;
    var score = $(rate).data('score') || 0;

    $(rate).raty({
      number: 10, scoreName: 'review[stars]',
      starHalf: '/images/star-half.png',
      starOff: '/images/star-off.png',
      starOn: '/images/star-on.png',
      readOnly: readOnly,
      score: score
    });
  });
}

$(document).on('turbolinks:load', () => {
  new App.Rate();
});
