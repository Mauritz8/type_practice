window.addEventListener("keydown", e => {
  const container = document.getElementById("str");
  const elems = Array.from(container.children);
  const game = elems.map(elem => {
    const ch = elem.innerHTML === "&nbsp;" ? " " : elem.innerHTML;
    const is_next = elem.id === "next";
    const is_correct = elem.classList.contains("correct");
    return { "ch" : ch, "is_next" : is_next, "is_correct" : is_correct };
  });
  
  fetch("/api/new_input", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ g: game, ch: e.key }),
  }).then(res => res.text())
    .then(text => {
      container.outerHTML = text;
    });
});
