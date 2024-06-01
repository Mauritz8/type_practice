let texts = [|
  "The sun was setting, casting a golden glow over the horizon. Birds chirped as they flew back to their nests, creating a symphony of nature. The gentle breeze carried the scent of blooming flowers, making the evening truly magical.";
  "In the heart of the city, skyscrapers towered above, their glass facades reflecting the bustling streets below. People hurried along the sidewalks, each lost in their own world. Amid the chaos, a street musician played a soothing melody, offering a moment of tranquility.";
  "The old library was a treasure trove of stories waiting to be discovered. Dusty shelves lined with books of all shapes and sizes filled the room. The quiet rustling of pages being turned was the only sound, creating a serene atmosphere for readers.";
  "As the storm raged outside, the fireplace crackled warmly, filling the room with a comforting glow. The rain pounded against the windows, but inside, it was cozy and safe. A cup of hot cocoa and a good book made the perfect companions for the evening.";
  "The mountain trail was steep and challenging, but the view from the top was worth every step. Endless green valleys stretched out below, dotted with wildflowers in full bloom. The crisp, fresh air filled the lungs, rejuvenating the spirit.";
  "At the farmer's market, stalls overflowed with fresh produce, homemade goods, and vibrant flowers. The aroma of baked bread and ripe fruit filled the air, inviting visitors to sample the local delights. Lively chatter and laughter added to the festive atmosphere.";
  "The beach was serene at dawn, with only the sound of waves gently lapping at the shore. The sky was painted in hues of pink and orange as the sun began to rise. A solitary figure walked along the water's edge, enjoying the peaceful solitude.";
  "In the small village, life moved at a slower pace. Neighbors greeted each other warmly, and children played freely in the streets. The simplicity of the surroundings brought a sense of calm and contentment to all who lived there.";
  "The concert hall was filled with anticipation as the lights dimmed and the orchestra took their places. The first notes of the symphony resonated through the room, captivating the audience. Each movement of the music told a story, evoking a range of emotions.";
  "The garden was a riot of color, with flowers of every hue blooming in harmony. Bees buzzed from blossom to blossom, busy with their work. The scent of roses and lavender filled the air, creating a tranquil escape from the everyday world.";
|]

let rand_elem arr = arr.(Random.int (Array.length arr))

let gen_text () = 
  Random.self_init ();
  rand_elem texts
