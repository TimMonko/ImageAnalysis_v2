// Timothy Monko -- Started: 07/05/2021
// monko001@umn.edu -- timmonko@gmail.com -- github.com/TimMonko

#@ File (style = "directory") input_folder
#@ File (style = "directory") output_folder

#@ Float (label = "Scale px-to-um") scale
#@ String (value = "1.575 = 10X ; 0.62 = 4X", visibility = "MESSAGE") scale_hint

#@ Boolean (label = "Pre-sized bin") bin_boolean
#@ String (label = "Height", value = 400) bin_height
#@ String (label = "Width", value = 850) bin_width

#@ Boolean (label = "Freehand bin") freehand_boolean

file_list = getFileList(input_folder);
Array.print(file_list);
//File.makeDirectory(input_folder + File.separator + output_folder);

for(i = 0; i < lengthOf(file_list); i++) {
	open(input_folder + File.separator + file_list[i]); 
	title = getTitle();
	getDimensions(w,h,channels,slices,frames);
	for (n = 0; n < channels; n++) {
			Stack.setChannel(n);
			resetMinAndMax();
		}
	run("Set Scale...", "distance=scale known=1 pixel=1 unit=µm global"); 
	if (bin_boolean == 1) {
		makeRectangle((w-bin_width*scale)/2, (h-bin_height*scale)/2, bin_width*scale, bin_height*scale);
		waitForUser("Press OK When Finished", "(1) Use 'Selection Rotator' on toolbar \n(2) Click and drag to rotate the bin \n(3) ALT+click or SHFT+click to move the bin");
		run("Add Selection...");
	}
	if (freehand_boolean == 1) {
		waitForUser("Press OK When Finished", "(1) Use the line tool or polygon tool \n(2) Distance is shown in the FIJI toolbar at the bottom \n(3) Press 'b' to add the line or polybox to the overlay");
		run("Add Selection...");
	}
	rename(title); 
	saveAs("tif",  output_folder + File.separator + title);
	print((i+1) + " of " + lengthOf(file_list));
	close();
}

