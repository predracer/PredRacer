import os
import subprocess
import time

from tqdm import tqdm

# Set the folder path and the path to analyse_appnew.sh
apk_folder = "/Users/Desktop/benchapp/300apk"
analyse_script = "./analyse_appnew.sh"

# Get the list of APK files in the folder
apk_files = [file for file in os.listdir(apk_folder) if file.endswith(".apk")]

# File to record results
result_file = "analysis_results.txt"

# Clear previous result file if it exists
with open(result_file, "w") as f:
    pass

# Get the total number of APKs
total_apks = len(apk_files)

# Iterate through each APK file and display a progress bar
for index, apk_file in enumerate(tqdm(apk_files, desc="Progress", total=total_apks)):
    apk_path = os.path.join(apk_folder, apk_file)

    # Record start time
    start_time = time.time()

    # Run the analyse_appnew.sh script
    subprocess.run([analyse_script, apk_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Record end time
    end_time = time.time()

    # Calculate the running time
    runtime = end_time - start_time

    # Write the runtime into the result file
    with open(result_file, "a") as f:
        f.write(f"APK File: {apk_file}, Runtime: {runtime:.2f} seconds\n")

print("Analysis complete. Results saved in", result_file)
