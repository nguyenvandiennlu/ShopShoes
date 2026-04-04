document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("[data-password-toggle]").forEach(function (button) {
    var targetId = button.getAttribute("data-target");
    var input = document.getElementById(targetId);
    var icon = button.querySelector("ion-icon");

    if (!input || !icon) {
      return;
    }

    button.addEventListener("click", function () {
      var isPassword = input.type === "password";

      input.type = isPassword ? "text" : "password";
      button.setAttribute("aria-pressed", String(isPassword));
      button.setAttribute(
        "aria-label",
        isPassword ? "Ẩn mật khẩu" : "Hiện mật khẩu"
      );
      icon.setAttribute("name", isPassword ? "eye-off-outline" : "eye-outline");
    });
  });
});