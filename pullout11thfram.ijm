title = getTitle();
run("Make Substack...", "frames=1-10,12-22");
title_color = getTitle();
run("Z Project...", "projection=[Max Intensity]");
resetMinAndMax();
selectWindow(title_color);
close();
selectWindow(title);
run("Make Substack...", "frames=11");
title_BF = getTitle();
selectWindow(title_BF);
resetMinAndMax();
run("Threshold...");