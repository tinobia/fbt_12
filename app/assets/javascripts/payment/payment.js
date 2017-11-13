document.addEventListener("turbolinks:load", function () {
  var elements = stripe.elements();

  var style = {
    base: {
      color: "#32325d",
      lineHeight: "18px",
      fontSize: "16px",
      "::placeholder": {
        color: "#aab7c4"
      }
    },
    invalid: {
      color: "#fa755a",
      iconColor: "#fa755a"
    }
  };

  function stripeTokenHandler(form, token) {
    $("#stripe-token").html('<input type="hidden" value="'+ token.id +'" name="stripe_token">');
    form.submit();
  }

  var card = elements.create("card", {style: style});

  card.mount("#card-element");

  card.addEventListener("change", function(event) {
    var displayError = document.getElementById("card-errors");
    if (event.error) {
      $(displayError).html("<div class=\"alert alert-danger\">" + event.error.message + "</div>");
    } else {
      $(displayError).textContent = "";
    }
  });

  var charge = document.getElementById("charge");

  var numberInput = document.getElementById("booking_request_number_of_people");

  numberInput.addEventListener("change", function(event) {
    var price = parseFloat($(charge).data("price"));
    var total = parseInt(event.target.value) * price;
    $(charge).html("<h2>" + "$ " + total + "</h2>");
  });

  var form = document.getElementById("booking-form");

  form.addEventListener("submit", function(event) {
    event.preventDefault();

    stripe.createToken(card).then(function(result) {
      if (result.error) {
        $("#card-errors").html("<div class=\"alert alert-danger\">" + result.error.message + "</div>");
      } else {
        stripeTokenHandler(form, result.token);
      }
    });
  });
});
