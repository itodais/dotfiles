require 'spec_helper'

str = <<-EOH
# dmidecode 2.12
SMBIOS 2.4 present.
10 structures occupying 326 bytes.
Table at 0x000F1EF0.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Seabios
	Version: 0.5.1
	Release Date: 01/01/2011
	Address: 0xE8000
	Runtime Size: 96 kB
	ROM Size: 64 kB
	Characteristics:
		BIOS characteristics not supported
		Targeted content distribution is supported
	BIOS Revision: 1.0

Handle 0x0100, DMI type 1, 27 bytes
System Information
	Manufacturer: Red Hat
	Product Name: KVM
	Version: RHEL 7.0.0 PC (i440FX + PIIX, 1996)
	Serial Number: Not Specified
	UUID: 5E317344-67C8-42D1-BD62-8587C8532251
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Red Hat Enterprise Linux

Handle 0x0300, DMI type 3, 20 bytes
Chassis Information
	Manufacturer: Bochs
	Type: Other
	Lock: Not Present
	Version: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: Unknown
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: Unspecified

Handle 0x0401, DMI type 4, 32 bytes
Processor Information
	Socket Designation: CPU 1
	Type: Central Processor
	Family: Other
	Manufacturer: Bochs
	ID: D3 06 00 00 FD FB 8B 07
	Version: Not Specified
	Voltage: Unknown
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 2000 MHz
	Status: Populated, Enabled
	Upgrade: Other
	L1 Cache Handle: Not Provided
	L2 Cache Handle: Not Provided
	L3 Cache Handle: Not Provided

Handle 0x1000, DMI type 16, 15 bytes
Physical Memory Array
	Location: Other
	Use: System Memory
	Error Correction Type: Multi-bit ECC
	Maximum Capacity: 512 MB
	Error Information Handle: Not Provided
	Number Of Devices: 1

Handle 0x1100, DMI type 17, 21 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: 0x0000
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM 0
	Bank Locator: Not Specified
	Type: RAM
	Type Detail: None

Handle 0x1300, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Array Handle: 0x1000
	Partition Width: 1

Handle 0x1400, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x1100
	Memory Array Mapped Address Handle: 0x1300
	Partition Row Position: 1

Handle 0x2000, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x7F00, DMI type 127, 4 bytes
End Of Table
EOH

describe Specinfra::HostInventory::Virtualization do
  virt = Specinfra::HostInventory::Virtualization.new(host_inventory) 
  let(:host_inventory) { nil }
  it 'Docker Image should return :system => "docker"' do
    allow(virt.backend).to receive(:run_command).with('ls /.dockerinit') do 
      CommandResult.new(:stdout => '/.dockerinit', :exit_status => 0)
    end  
    # although there is most likely no dmidecode on a docker image
    # this is to make sure the code is only reporting docker 
    allow(virt.backend).to receive(:run_command).with('ls /usr/sbin/dmidecode') do
      CommandResult.new(:stdout => '/usr/sbin/dmidecode', :exit_status => 0)
    end 
    allow(virt.backend).to receive(:run_command).with('dmidecode') do 
      CommandResult.new(:stdout => str, :exit_status => 0)
    end 
    expect(virt.get).to include(
      :system => 'docker'
    )
  end
end
