title = getTitle();
run("Split Channels");
selectWindow("C1-" + title);
title_c1 = getTitle();
run("Z Project...", "projection=[Max Intensity]");
/*
title_zproj_BF = getTitle();
title_zproj_BF = substring(title_zproj_BF,7);
rename(title_zproj_BF);
selectWindow(title_c1);
resetMinAndMax();
close();
selectWindow("C2-" + title);
title_c2 = getTitle();
run("Z Project...", "projection=[Max Intensity]");
title_zproj_FL = getTitle();
title_zproj_FL = substring(title_zproj_FL,7);
rename(title_zproj_FL);
selectWindow(title_c2);
resetMinAndMax();
close();
resetMinAndMax();
selectWindow(title_zproj_BF);
run("Threshold...");
*/