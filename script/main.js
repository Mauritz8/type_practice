window.addEventListener("keydown", e => {
  if (e.key == ' ') e.preventDefault();

  const container = document.getElementById("text-box");
  const elems = Array.from(container.getElementsByClassName("ch"));
  const text = elems.map(elem => {
    const ch = elem.innerHTML === "&nbsp;" ? " " : elem.innerHTML;
    const is_next = elem.id === "next";
    const state = elem.classList.contains("correct") ? ["Correct"]
      : elem.classList.contains("wrong") ? ["Wrong"]
      : ["Default"];
    return { "ch" : ch, "state" : state, "is_next" : is_next };
  });
  const errors = parseInt(container.querySelector("#errors").value);

  fetch("/api/new_input", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ typing_data: { text: text, errors: errors}, key: e.key }),
  }).then(res => res.text())
    .then(text => {
      container.outerHTML = text;
    });
});
