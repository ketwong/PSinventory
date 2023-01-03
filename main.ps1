function Mock-Inventory {
    
    # Create an empty array to store the inventory objects
    $inventory = @()

    # Create the first inventory object and add properties for grocery item, quantity, and weight
    $item1 = New-Object -TypeName PSObject
    $item1 | Add-Member -MemberType NoteProperty -Name 'Grocery Item' -Value 'Orange'
    $item1 | Add-Member -MemberType NoteProperty -Name Quantity -Value 3
    $item1 | Add-Member -MemberType NoteProperty -Name Weight -Value 10

    # Add the first inventory object to the array
    $inventory += $item1

    # Create the second inventory object and add properties for grocery item, quantity, and weight
    $item2 = New-Object -TypeName PSObject
    $item2 | Add-Member -MemberType NoteProperty -Name 'Grocery Item' -Value 'Milk'
    $item2 | Add-Member -MemberType NoteProperty -Name Quantity -Value 2
    $item2 | Add-Member -MemberType NoteProperty -Name Weight -Value 500

    # Add the second inventory object to the array
    $inventory += $item2

    # Calculate the total weight for each item
    foreach ($item in $inventory) {
        $totalWeight = $item.Quantity * $item.Weight
        $item | Add-Member -MemberType NoteProperty -Name 'Total Weight' -Value $totalWeight
    }

    # Display the inventory table
    $inventory | Select-Object 'Grocery Item', Quantity, Weight, 'Total Weight'
}

# # Get the mock inventory table
# $inventories = Mock-Inventory 

# # Display the inventory table
# $inventories


function Backup-Inventory ($PSObjectVar) {

    # Get the current date and time
    $dateTime = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'

    # Export the inventory table to a CSV file
    $PSObjectVar  | Export-Csv -Path "C:\Users\suket\Documents\git\PSInventory\backup\inventory-$dateTime.csv" -NoTypeInformation -NoClobber -Force
} 

# Export the inventory table to a CSV file
#Backup-Inventory -PSObjectVar $inventories

function Read-Inventory {

    # Import the CSV file
    $inventories = Import-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv"

    # Return the imported data
    return $inventories
}

# # Import the inventory data from the CSV file
$inventories = Read-Inventory 

# # Display the imported data
$inventories

function Add-InventoryItem {
    param(
        [string]$GroceryItem,
        [int]$Quantity,
        [int]$Weight

    )

    # Import the CSV file
    $global:inventory = Import-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv"

    # Create a new inventory object and add properties for grocery item, quantity, and weight
    $item = New-Object -TypeName PSObject
    $item | Add-Member -MemberType NoteProperty -Name 'Grocery Item' -Value $GroceryItem
    $item | Add-Member -MemberType NoteProperty -Name Quantity -Value $Quantity
    $item | Add-Member -MemberType NoteProperty -Name Weight -Value $Weight

    # Calculate the total weight for the new item
    $totalWeight = $Quantity * $Weight
    $item | Add-Member -MemberType NoteProperty -Name 'Total Weight' -Value $totalWeight

    # Add the new item to the inventory
    $global:inventory += $item

    # Export the updated inventory to the CSV file
    $global:inventory | Export-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv" -NoTypeInformation -Force
}

# # Add a new item to the inventory
# Add-InventoryItem -GroceryItem '456' -Quantity 5 -Weight 20

function Remove-InventoryItem {
    param(
        [string]$GroceryItem
    )

    # Import the CSV file
    $inventories = Import-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv"

    # Remove the specified item from the inventory
    $inventories = $inventories | Where-Object { $_.'Grocery Item' -ne $GroceryItem }

    # Export the updated inventory to the CSV file
    $inventories | Export-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv" -NoTypeInformation -Force
}

# Remove an item from the inventory
Remove-InventoryItem -GroceryItem *test*

function Restore-InventoryItem {
    param(
        [string]$BackupPath
    )

    # Import the backup CSV file
    $inventory = Import-Csv -Path $BackupPath

    # Export the restored inventory to the original CSV file
    $inventory | Export-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv" -NoTypeInformation -Force
}

# Restore the inventory from a backup CSV file
Restore-InventoryItem -BackupPath "C:\Users\suket\Documents\git\PSInventory\backup\inventory-2022-12-26_17-22-47.csv" 

function Update-InventoryItem {
    param(
        [string]$GroceryItem,
        [int]$Quantity,
        [int]$Weight
    )

    # Import the CSV file
    $inventory = Import-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv"

    # Find the item to be updated
    $item = $inventory | Where-Object { $_.'Grocery Item' -eq "Orange" }

    # Update the quantity and weight of the item
    $item.Quantity = $Quantity
    $item.Weight = $Weight

    # Calculate the new total weight for the item
    $totalWeight = $Quantity * $Weight
    $item.'Total Weight' = $totalWeight

    # Export the updated inventory to the CSV file
    $inventory | Export-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv" -NoTypeInformation -Force
}

# Update an item in the inventory
Update-InventoryItem -GroceryItem 'Orange' -Quantity 3 -Weight 20


function Clean-InventoryItem {
    # Import the CSV file
    $inventory = Import-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv"

    # Group the inventory items by grocery item
    $groups = $inventory | Group-Object -Property 'Grocery Item'

    # Initialize the cleaned inventory
    $cleanedInventory = @()

    # Iterate through the groups
    foreach ($group in $groups) {
        # Get the first item in the group
        $item = $group.Group[0]

        # Sum the quantities and weights of all items in the group
        $sumQuantity = ($group.Group | Measure-Object -Property Quantity -Sum).Sum
        $sumWeight = ($group.Group | Measure-Object -Property Weight -Sum).Sum

        # Calculate the total weight for the merged item
        $totalWeight = $sumQuantity * $sumWeight

        # Update the quantity, weight, and total weight of the merged item
        $item.Quantity = $sumQuantity
        $item.Weight = $sumWeight
        $item.'Total Weight' = $totalWeight

        # Add the merged item to the cleaned inventory
        $cleanedInventory += $item
    }

    # Export the cleaned inventory to the CSV file
    $cleanedInventory | Export-Csv -Path "C:\Users\suket\Documents\git\PSInventory\inventory.csv" -NoTypeInformation -Force
}

# Merge duplicate rows in the inventory
Clean-InventoryItem

