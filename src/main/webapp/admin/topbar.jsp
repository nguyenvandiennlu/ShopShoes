<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<style>
  .admin-topbar {
    position: fixed;
    top: 0;
    right: 0;
    left: 250px;
    height: 70px;
    background: #ffffff;
    border-bottom: 1px solid #e9ecef;
    z-index: 1035;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 22px;
  }
  .admin-topbar-search {
    position: relative;
    width: 320px;
    max-width: 45vw;
  }
  .admin-topbar-search .material-symbols-outlined {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: #6c757d;
    font-size: 24px;
  }
  .admin-topbar-search input {
    width: 100%;
    height: 46px;
    border: none;
    outline: none;
    border-radius: 999px;
    background: #eef0f2;
    color: #495057;
    padding: 0 16px 0 46px;
    font-size: 20px;
  }
  .admin-topbar-search input::placeholder {
    color: #7b8088;
  }
  .admin-topbar-actions {
    display: flex;
    align-items: center;
    gap: 14px;
  }
  .admin-topbar-icon {
    width: 38px;
    height: 38px;
    border: 0;
    border-radius: 50%;
    background: transparent;
    color: #5f6670;
    display: inline-flex;
    align-items: center;
    justify-content: center;
  }
  .admin-topbar-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid #d7dbe0;
  }
</style>

<header class="admin-topbar">
  <div class="admin-topbar-search">
    <span class="material-symbols-outlined">search</span>
    <input type="text" placeholder="Tìm kiếm..." />
  </div>
  <div class="admin-topbar-actions">
    <button class="admin-topbar-icon" type="button"><span class="material-symbols-outlined">notifications</span></button>
    <button class="admin-topbar-icon" type="button"><span class="material-symbols-outlined">help</span></button>
    <img class="admin-topbar-avatar" alt="Admin" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAMp0kgdk0DeGlgBivcAkZG-40tKGlG-JRdll_ATLdVN4kTdQWYSBcZGxaOLWJsN95YvnMFqbFYMzGrZetbZz0s4xQ5HmxZOA76hdrnh9XWPn2HPOdEoltpvm31wv4gJR1TSS3WN6INJgFBgvll3ldPjWAQ6ck7UA4vF8F7Q-shsCxm25rzKnelI2Pqe47bv9GniqUQgpskt6ID-EnvGkPoNkSe3J1-LMwiNY1ANYml3VhpmZskksvJ1ToQ8cRU6c2rJiLLWdFpTEa2" />
  </div>
</header>
