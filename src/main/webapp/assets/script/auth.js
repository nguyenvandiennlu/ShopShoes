// File: assets/script/auth.js

import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

// Firebase Config (của bạn - GIỮ NGUYÊN)
const firebaseConfig = {
  apiKey: "AIzaSyCihucCpq_GiE6v4sM9ytpVkf9kEub01Os",
  authDomain: "login-gg-c46e0.firebaseapp.com",
  projectId: "login-gg-c46e0",
  storageBucket: "login-gg-c46e0.firebasestorage.app",
  messagingSenderId: "219207162402",
  appId: "1:219207162402:web:011e518cc18341254f887b",
};

// Khởi tạo Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const provider = new GoogleAuthProvider();

provider.setCustomParameters({
  prompt: "select_account",
});

console.log("Firebase đã được khởi tạo");

document.addEventListener("DOMContentLoaded", function () {
  const googleBtn = document.getElementById("google-login-btn");

  if (googleBtn) {
    googleBtn.addEventListener("click", (e) => {
      e.preventDefault();

      console.log("Bắt đầu đăng nhập Google...");

      signInWithPopup(auth, provider)
        .then((result) => {
          const user = result.user;
          console.log(" Đăng nhập Google thành công:", user.email);
          return fetch("google-login", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              email: user.email,
              name: user.displayName,
              uid: user.uid,
              photoURL: user.photoURL || "",
            }),
          });
        })
        .then((response) => {
          console.log("Server status:", response.status);
          console.log("Content-Type:", response.headers.get("content-type"));

          const contentType = response.headers.get("content-type");
          if (contentType && contentType.includes("application/json")) {
            return response.json();
          } else {
            return response.text().then((text) => {
              console.error(
                "Server trả về HTML thay vì JSON:",
                text.substring(0, 200)
              );
              throw new Error(
                "Server không trả về JSON. Có thể servlet chưa được deploy đúng."
              );
            });
          }
        })
        .then((data) => {
          if (data.success) {
            console.log(" Đăng nhập thành công!");
            window.location.href = data.redirect;
          } else {
            alert("Đăng nhập thất bại: " + data.error);
          }
        })
        .catch((error) => {
          console.error(" Lỗi:", error);

          if (error.code === "auth/popup-closed-by-user") {
            console.log("User đóng popup");
          } else {
            alert("Không thể đăng nhập: " + error.message);
          }
        });
    });

    console.log("Đã gắn sự kiện click vào nút Google Login");
  } else {
    console.warn(" Không tìm thấy nút #google-login-btn");
  }
});
