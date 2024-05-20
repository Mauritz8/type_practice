window.addEventListener("keydown", e => {
  const elems = Array.from(document.getElementById("str").children);
  const game = elems.map(elem => {
    const ch = elem.innerHTML;
    const is_next = elem.id === "next";
    const is_correct = elem.classList.contains("correct");
    return { "ch" : ch, "is_next" : is_next, "is_correct" : is_correct };
  });
  
  fetch("api/newinput", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ game: game, input_ch: e.key }),
  });
});
