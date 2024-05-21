window.addEventListener("keydown", e => {
  if (e.key.length > 1) return;
  if (e.key == ' ') e.preventDefault();

  const container = document.getElementById("str");
  const elems = Array.from(container.getElementsByClassName("ch"));
  const text = elems.map(elem => {
    const ch = elem.innerHTML === "&nbsp;" ? " " : elem.innerHTML;
    const is_next = elem.id === "next";
    const is_correct = elem.classList.contains("correct");
    return { "ch" : ch, "is_correct" : is_correct, "is_next" : is_next };
  });
  const errors = parseInt(container.querySelector("#errors").value);

  fetch("/api/new_input", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ typing_data: { text: text, errors: errors}, ch: e.key }),
  }).then(res => res.text())
    .then(text => {
      container.outerHTML = text;
    });
});
