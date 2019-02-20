new-vm -Name New-WinSVR -MemoryStartupBytes 750mb -Generation 2 -NewVHDPath C:\VMs\New-WinSVR.vhd -NewVHDSizeBytes 40gb -BootDevice vhd

Add-VMDvdDrive New-WinSVR

Start-Sleep -Seconds 5

Set-VMDvdDrive -VMName New-WinSVR -Path "C:\install\SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-2_MLF_X21-22843.ISO" -ToControllerNumber 0 -ToControllerLocation 1

Start-Sleep -Seconds 5

$dvd = Get-VMDvdDrive -VMName New-WinSVR

Set-VMFirmware -VMName New-WinSVR -FirstBootDevice $dvd

Start-Sleep -Seconds 5

start-vm New-WinSVR