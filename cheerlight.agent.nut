url <- "http://api.thingspeak.com/channels/1417/field/1/last.txt";
INTERVAL_SECS <- 10
server.log("Hello from the device!")

currentColour <- { r=0, g=0, b=0 }

function setColour(colours) {
    if (currentColour.r == colours.r && currentColour.g == colours.g && currentColour.b == colours.g) {
        server.log("Colour is same.");
        return;
    }
    currentColour = colours;
    sendColour();
}

function sendColour() {
    device.send("colour", currentColour);
}

function fetchCheerlightValue() {
    local request = http.get(url);
    local response = request.sendsync();
    return response.body;
}

function hexForName(name) {
    local colours = {
        black = "#000000"
        silver = "#C0C0C0"
        gray = "#808080"
        white = "#FFFFFF"
        warmwhite = "#FFFFFF"
        oldlace = "#FFFFFF"
        maroon = "#800000"
        red = "#FF0000"
        purple = "#800080"
        fuchsia = "#FF00FF"
        green = "#008000"
        aqua = "#00FFFF"
        lime = "#00FF00"
        olive = "#808000"
        yellow = "#FFFF00"
        navy = "#000080"
        blue = "#0000FF"
        teal = "#008080"
        orange = "#FFA500"
        cyan = "#00FFFF"
        magenta = "#FF00FF"
        pink = "#FFC0CB"
      };

    if (colours[name]) {
        return colours[name];
    } else {
        return "#FF0000"
    }
}

function Hex2RGB(v)
{
    local vString = v.tostring().toupper();
    local hexChars = "0123456789ABCDEF";

    // // Make sure it's 6 digits long
    if(vString.len() == 6)
    {
        return {
            r = (hexChars.find(vString[0].tochar())*16) + hexChars.find(vString[1].tochar())
            g = (hexChars.find(vString[2].tochar())*16) + hexChars.find(vString[3].tochar())
            b = (hexChars.find(vString[4].tochar())*16) + hexChars.find(vString[5].tochar())
        }
    }
}


function update() {
    server.log("update:")
    local colour = fetchCheerlightValue();
    server.log(" colour " + colour);
    setColourFromName(colour);
    imp.wakeup(INTERVAL_SECS, update);
}

function setColourFromName(colour) {
    local hex = hexForName(colour);
    server.log(" hex " + hex);
    local rgb = Hex2RGB(hex.slice(1));
    server.log(" rgb " + rgb.r + " " + rgb.g + " " + rgb.b);
    setColour(rgb);
}

device.onconnect(
    function() {
        server.log("Device connected to agent");
        sendColour();
    }
);

update();
