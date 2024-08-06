document.addEventListener("DOMContentLoaded", (event) => {
  function isMobileDevice() {
    return /Android|webOS|iPhone|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
      navigator.userAgent
    );
  }

  let adElement = document.getElementById("ad-ins");
  let isMobile = isMobileDevice();

  if (isMobile) {
    adElement.style.display = "none";
    adElement.setAttribute("data-ad-format", "270x90");
    adElement.setAttribute("data-ad-slot", "mobile-banner");
  } else {
    adElement.setAttribute("data-ad-format", "728x90");
    adElement.setAttribute("data-ad-slot", "leaderboard-desktop");
  }

  let script = document.createElement("script");
  script.async = true;
  script.src = "https://v1.slise.xyz/scripts/embed.js";
  script.onload = () => {
    (adsbyslise = window.adsbyslise || []).push({});
  };
  document.head.appendChild(script);
});
