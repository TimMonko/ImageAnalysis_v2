/*
* Macro to count nuclei in multiple images in a folder/subfolders.
*/
#@File (label = "Input dir", style = "directory") input
#@File (label = "Output dir", style = "directory") output
#@File (label = "File suffix", value = ".tif") suffix

#@ Float (label = "Scale px-to-um") scale
#@ String (value = "1.575 = 10X ; 0.62 = 4X", visibility = "MESSAGE") scale_hint

#@ Boolean (label = "Pre-sized bin") bin_boolean
#@ String (label = "Height", value = 400) bin_height
#@ String (label = "Width", value = 850) bin_width

#@ Boolean (label = "Freehand bin") freehand_boolean

//LUT_list = newArray("Cyan", "Magenta", "Yellow", "Grays");
// input = input + File.separator;

processFolder(input);
	
// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < lengthOf(list); i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder("" + input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
	//saves results for all images in a single file
	saveAs("Results", output + "/All_Results.csv"); 
}

function processFile(input, output, file) {
	setBatchMode(false); // prevents image windows from opening while the script is running
	// open image using Bio-Formats
	run("Bio-Formats", "open=[" + input + "/" + file +"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
} 







processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < lengthOf(list); i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder("" + input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
	//saves results for all images in a single file
	saveAs("Results", output + "/All_Results.csv"); 
}



function processFile(input, output, file) {
//	run("Bio-Formats Importer", "open= [" + input + "/" + file +"] autoscale color_mode=Composite display_rois rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	setBatchMode(false); // prevents image windows from opening while the script is running
	// open image using Bio-Formats
	run("Bio-Formats", "open=[" + input + "/" + file +"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
}


	title = getTitle();
	id = getImageID();
	print(title + id);
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
	print((i+1) + " of " + lengthOf(list) + " :  " + title);
	close(title);
}


