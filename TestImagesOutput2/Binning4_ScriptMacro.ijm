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

input_dir = input_folder + File.separator;
file_list = getFileList(input_dir);

LUT_list = newArray("Cyan", "Magenta", "Yellow", "Grays");

for(i = 0; i < lengthOf(file_list); i++) {
	open(input_folder + File.separator + file_list[i]);
	//recursive finding of tif stacks within subdirectories which often occur due to microscope saving format, can be modified to open those in a folder and stack, but images should not be separated
	//file_name = input_folder + File.separator + file_list[i];
	//if (endsWith(file_name, "/")) { 
	//	file_sub = getFileList(file_name);
	//	file_name = file_name + file_sub[0];	
	//} 
	//run("Bio-Formats Importer", "open=file_name autoscale color_mode=Composite display_rois rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	title = getTitle();
	getDimensions(w,h,channels,slices,frames);
	run("Set Scale...", "distance=scale known=1 pixel=1 unit=µm global"); 
	run("Make Composite", "display=Composite");

	for (n = 0; n < channels; n++) {
			Stack.setChannel(n+1);
			run(LUT_list[n]);
			resetMinAndMax();
	}
		
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
	print((i+1) + " of " + lengthOf(file_list) + " :  " + title);
	close(title);
}

