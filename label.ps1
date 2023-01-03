# Navigate to the folder containing the images
cd C:\Users\suket\Documents\git\PSInventory\images\raw

# Retrieve a list of all the images in the folder
$images = Get-ChildItem -Filter *.jpg

# Iterate over each image in the list
$images | Foreach-Object {
    # Prompt the user to enter a label for the current image
    $label = Read-Host "Enter a label for image $($_.Name):"

    # Save the label to a file with the same name as the image, but with a different extension
    Set-Content -Path "$($_.BaseName).txt" -Value $label
}