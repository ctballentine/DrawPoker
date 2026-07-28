let discard = [];

$(document).on('turbolinks:load', function() {
  // Initialization code can go here if needed
});

const editDiscard = function(discardUrl, discardValues) {
  $.ajax({
    url: discardUrl,            // Will hit /games/:id/edit
    type: "GET",
    timeout: 10000,
    dataType: "script",         // Forces the browser to execute the response code
    data: {
      discard: discardValues    // Sends just your array values over the network
    },
    success: function() {
      console.log("Discard network request completed successfully!");
    },
    error: function(xhr, status, error) {
      console.log("Discard error:", error);
    }
  });
};

window.discard = function(game) {
  if (game === "" || !game) {
    window.newGame();
  } else {
    discard = [];
    discardArray();

    // Construct a standard resourceful REST URL path:
    const discardUrl = "/games/" + game.toString() + "/edit";

    editDiscard(discardUrl, discard);
  }
};


window.newGame = function() {
  $.ajax({
    url: "/games/new",
    type: "GET",
    timeout: 10000,
    dataType: "script",
    data: {},
    success: function() {
      discard = [];
    },
    error: function() {
      console.log("new game ajax does not work!");
    }
  });
};

window.suggestDiscard = function() {
  const game = $('.game').attr('data-game');
  $.ajax({
    url: "/games/show",
    type: "GET",
    timeout: 10000,
    dataType: "script",
    data: { game: game },
    success: function() {},
    error: function() {
      console.log("discard suggestion does not work!");
    }
  });
};

const newGameInternal = function() {
  $.ajax({
    url: "/games/new",
    type: "GET",
    timeout: 10000,
    dataType: "script",
    data: {},
    success: function() {
      discard = [];
    },
    error: function() {
      console.log("internal new game ajax does not work!");
    }
  });
};

window.colorToggle = function(card) {
  if (card.style.backgroundColor === "rgb(255, 200, 0)") {
    card.style.backgroundColor = "";
  } else {
    card.style.backgroundColor = "rgb(255, 200, 0)";
  }
};

const discardArray = function() {
  if ($("#p0").css("backgroundColor") === "rgb(255, 200, 0)") {
    discard.push("0");
  }
  if ($("#p1").css("backgroundColor") === "rgb(255, 200, 0)") {
    discard.push("1");
  }
  if ($("#p2").css("backgroundColor") === "rgb(255, 200, 0)") {
    discard.push("2");
  }
  if ($("#p3").css("backgroundColor") === "rgb(255, 200, 0)") {
    discard.push("3");
  }
  if ($("#p4").css("backgroundColor") === "rgb(255, 200, 0)") {
    discard.push("4");
  }
};
