(function() {
  $(() => {

    $(".show-more").on("click", function() {
      /* eslint-disable no-invalid-this */
      $(this).hide();
      $(".show-more-panel").removeClass("hide");
      $(".hide-more").show();
    });

  })
}(window));
