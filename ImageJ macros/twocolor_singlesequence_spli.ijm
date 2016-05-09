//run("Bio-Formats Importer");
title = getTitle();
selectWindow(title);
run("Make Substack...", "frames=1-21");
//run("Make Substack...", "slices=1 frames=1-21-2");
run("Z Project...", "projection=[Max Intensity]");
resetMinAndMax();