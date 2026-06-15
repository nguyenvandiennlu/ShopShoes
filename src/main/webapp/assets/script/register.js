document.addEventListener("DOMContentLoaded", function () {
  var form = document.getElementById("register");
  if (!form) {
    return;
  }

  var fields = {
    fullName: document.getElementById("fullName"),
    email: document.getElementById("email"),
    phone: document.getElementById("phone"),
    address: document.getElementById("address"),
    password: document.getElementById("password"),
    confirmPassword: document.getElementById("confirmPassword")
  };

  var feedbacks = {
    fullName: document.getElementById("fullNameFeedback"),
    email: document.getElementById("emailFeedback"),
    phone: document.getElementById("phoneFeedback"),
    address: document.getElementById("addressFeedback"),
    password: document.getElementById("passwordFeedback"),
    confirmPassword: document.getElementById("confirmPasswordFeedback")
  };

  var validationTimer = null;
  var validationSequence = 0;
  var touched = {
    fullName: false,
    email: false,
    phone: false,
    address: false,
    password: false,
    confirmPassword: false
  };

  function collectPayload() {
    return {
      action: "validate",
      fullName: fields.fullName.value,
      email: fields.email.value,
      phone: fields.phone.value,
      address: fields.address.value,
      password: fields.password.value,
      confirmPassword: fields.confirmPassword.value
    };
  }

  function markInputState(input, isValid) {
    if (!input) {
      return;
    }
    input.classList.remove("input-valid", "input-invalid");
    if (isValid) {
      input.classList.add("input-valid");
    } else {
      input.classList.add("input-invalid");
    }
  }

  function renderFieldFeedback(fieldName, result, forceRender) {
    var feedback = feedbacks[fieldName];
    var input = fields[fieldName];
    var rulesWrapper = document.querySelector(".password-rules");

    if (!feedback || !result) {
      return;
    }

    if (!forceRender && !touched[fieldName]) {
      feedback.textContent = "";
      feedback.classList.remove("is-valid", "is-invalid");
      if (input) {
        input.classList.remove("input-valid", "input-invalid");
      }
      if (fieldName === "password" && rulesWrapper) {
        rulesWrapper.classList.remove("is-collapsed");
      }
      return;
    }

    feedback.textContent = result.message || "";
    feedback.classList.remove("is-valid", "is-invalid");
    feedback.classList.add(result.valid ? "is-valid" : "is-invalid");
    markInputState(input, result.valid);

    if (fieldName === "password" && rulesWrapper) {
      rulesWrapper.classList.toggle("is-collapsed", !!result.valid);
    }
  }

  function renderPasswordRules(passwordResult, forceRender) {
    if (!passwordResult || !passwordResult.rules) {
      return;
    }

    if (!forceRender && !touched.password) {
      return;
    }

    var rules = passwordResult.rules;
    var rulesWrapper = document.querySelector(".password-rules");
    var ruleNodes = document.querySelectorAll(".password-rules li[data-rule]");
    var remainingInvalidRules = 0;

    ruleNodes.forEach(function (ruleNode) {
      var key = ruleNode.getAttribute("data-rule");
      if (!Object.prototype.hasOwnProperty.call(rules, key)) {
        return;
      }

      var isRuleOk = !!rules[key];
      ruleNode.classList.toggle("rule-ok", isRuleOk);
      ruleNode.classList.toggle("rule-visible", !isRuleOk);
      ruleNode.hidden = isRuleOk;
      ruleNode.setAttribute("aria-hidden", String(isRuleOk));

      if (!isRuleOk) {
        remainingInvalidRules += 1;
      }
    });

    if (rulesWrapper) {
      rulesWrapper.classList.toggle("is-collapsed", remainingInvalidRules === 0);
      
      // Hide/show the rule title based on whether all rules are valid
      var ruleTitle = rulesWrapper.querySelector(".rule-title");
      if (ruleTitle) {
        var allRulesValid = remainingInvalidRules === 0;
        ruleTitle.hidden = allRulesValid;
        ruleTitle.setAttribute("aria-hidden", String(allRulesValid));
      }
    }
  }

  function postValidation(forceRender) {
    validationSequence += 1;
    var requestId = validationSequence;

    return fetch(form.action, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-Requested-With": "XMLHttpRequest"
      },
      body: new URLSearchParams(collectPayload()).toString()
    })
        .then(function (response) {
          if (!response.ok) {
            throw new Error("Validation request failed");
          }
          return response.json();
        })
        .then(function (data) {
          if (requestId !== validationSequence || !data || !data.fields) {
            return null;
          }

          renderFieldFeedback("fullName", data.fields.fullName, forceRender);
          renderFieldFeedback("email", data.fields.email, forceRender);
          renderFieldFeedback("phone", data.fields.phone, forceRender);
          renderFieldFeedback("address", data.fields.address, forceRender);
          renderFieldFeedback("password", data.fields.password, forceRender);
          renderFieldFeedback("confirmPassword", data.fields.confirmPassword, forceRender);
          renderPasswordRules(data.fields.password, forceRender);
          return data;
        })
        .catch(function () {
          return null;
        });
  }

  function scheduleValidation(delay) {
    clearTimeout(validationTimer);
    validationTimer = setTimeout(function () {
      postValidation(false);
    }, delay);
  }

  [
    fields.fullName,
    fields.email,
    fields.phone,
    fields.address,
    fields.password,
    fields.confirmPassword
  ].forEach(function (input) {
    if (!input) {
      return;
    }
    var fieldName = input.id;
    input.addEventListener("input", function () {
      if (Object.prototype.hasOwnProperty.call(touched, fieldName)) {
        touched[fieldName] = true;
      }
      scheduleValidation(250);
    });
    input.addEventListener("blur", function () {
      if (Object.prototype.hasOwnProperty.call(touched, fieldName)) {
        touched[fieldName] = true;
      }
      scheduleValidation(0);
    });
  });

  form.addEventListener("submit", function (event) {
    event.preventDefault();

    Object.keys(touched).forEach(function (key) {
      touched[key] = true;
    });

    // Show loading overlay IMMEDIATELY (before any validation)
    var loadingOverlay = document.getElementById('registerLoadingOverlay');
    if (loadingOverlay) {
      loadingOverlay.classList.add('active');
      document.body.style.overflow = 'hidden';
    }

    // Validate reCAPTCHA
    var recaptchaResponse = '';
    if (typeof grecaptcha !== 'undefined') {
      recaptchaResponse = grecaptcha.getResponse();
    }
    var recaptchaFeedback = document.getElementById('recaptchaFeedback');
    if (!recaptchaResponse) {
      if (recaptchaFeedback) {
        recaptchaFeedback.textContent = 'Vui lòng xác nhận bạn không phải robot';
        recaptchaFeedback.classList.add('is-invalid');
      }
      // Hide loading overlay since we can't proceed
      if (loadingOverlay) {
        loadingOverlay.classList.remove('active');
        document.body.style.overflow = '';
      }
      return;
    } else {
      if (recaptchaFeedback) {
        recaptchaFeedback.textContent = '';
        recaptchaFeedback.classList.remove('is-invalid');
      }
    }

    postValidation(true).then(function (data) {
      if (data && data.valid) {
        // Append reCAPTCHA response to form before submitting
        var recaptchaInput = document.createElement('input');
        recaptchaInput.type = 'hidden';
        recaptchaInput.name = 'g-recaptcha-response';
        recaptchaInput.value = recaptchaResponse;
        form.appendChild(recaptchaInput);
        // Use setTimeout to allow the loading overlay to render before form submit
        setTimeout(function () {
          form.submit();
        }, 100);
        return;
      }

      // Hide loading overlay when validation fails or errors occur
      if (loadingOverlay) {
        loadingOverlay.classList.remove('active');
        document.body.style.overflow = '';
      }

      if (!data || !data.fields) {
        return;
      }

      var order = ["fullName", "email", "phone", "address", "password", "confirmPassword"];
      for (var i = 0; i < order.length; i += 1) {
        var key = order[i];
        if (data.fields[key] && data.fields[key].valid === false && fields[key]) {
          fields[key].focus();
          break;
        }
      }
    });
  });

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
      button.setAttribute("aria-label", isPassword ? "Ẩn mật khẩu" : "Hiện mật khẩu");
      icon.setAttribute("name", isPassword ? "eye-off-outline" : "eye-outline");
    });
  });

});