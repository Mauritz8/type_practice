let handler = Promise.resolve();
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
  const start_time = container.querySelector("#start_time").value;
  const body = {
    typing_data: {
      text: text, errors: errors,
      start_time: start_time === "" ? null : parseFloat(start_time)
    },
    key: e.key
  };

  handler = fetch("/api/new_input", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  }).then(res => res.text())
    .then(text => {
      container.outerHTML = text;
      htmx.process(document.body);
    });
});
