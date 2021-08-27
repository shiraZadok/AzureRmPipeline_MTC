        #Make sure that I run this command against the VMs in the right Subscription
        Set-AzContext -Subscription $subscriptionID
      
        $srcStorageAccountContext = (Get-AzStorageAccount -ResourceGroupName $myResourceGroupName -Name $srcStorageAccountName).Context
        $destStorageAccountContext = (Get-AzStorageAccount -ResourceGroupName $myResourceGroupName -Name $destStorageAccountName).Context
        $srcContainer = "sourcecontainer"
        $destContainer = "destcontainer"

        #Create source and destination container
        New-AzStorageContainer -Name $srcContainer -Context $srcStorageAccountContext -Permission blob
        New-AzStorageContainer -Name $destContainer -Context $destStorageAccountContext -Permission blob
          
        $srcStorageKey = Get-AzStorageAccountKey -Name $srcStorageAccountName `
        -ResourceGroupName $myResourceGroupName 
        $srcContext = New-AzStorageContext -StorageAccountName $srcStorageAccountName `
                                      -StorageAccountKey $srcStorageKey.Value[0] 
        #Upload 100 blobs
        Get-ChildItem -Path C:\Users\shira.zadok\Desktop\100Blobs | Set-AzStorageBlobContent -Container $srcContainer `
        -Context $srcContext -Force

        #Copy 100 blob
        azcopy copy "https://A.blob.core.windows.net/sourcecontainer?sv=2020-08-04&ss=bfqt&srt=co&sp=rwdlacuptfx&se=2021-09-10T04:03:56Z&st=2021-08-26T20:03:56Z&spr=https&sig=f4o4yp8lW8nTmwk9rI6hH6aJpp81DkW%2FoyEC1x7i8mU%3D" "https://B.blob.core.windows.net/destcontainer?sv=2020-08-04&ss=bfqt&srt=co&sp=rwdlacuptfx&se=2021-09-10T04:05:44Z&st=2021-08-26T20:05:44Z&spr=https&sig=lRf8nc%2FJnoX%2BAzGQBzVIXsmcRZggPWO2RCoSzYIVOjE%3D" --recursive
