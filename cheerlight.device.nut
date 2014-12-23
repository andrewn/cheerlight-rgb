red   <- hardware.pin9;
green <- hardware.pin7;
blue  <- hardware.pin8;

red.configure(PWM_OUT, 0.01, 0);
green.configure(PWM_OUT, 0.01, 0);
blue.configure(PWM_OUT, 0.01, 0);

function colour(col) {
  server.log("Colour: r " + col.r + ", g " + col.g + ", b " + col.b);

  local r = col.r / 255.0;
  local g = col.g / 255.0;
  local b = col.b / 255.0;

  server.log("Writing: r " + r + ", g " + g + ", b " + b);

  red.write(r);
  green.write(g);
  blue.write(b);
}
 

colour({ r = 0, g = 0, b = 0 });

agent.on("colour", colour);