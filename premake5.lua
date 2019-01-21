solution "SwiftOS"
	architecture	"x86"
	location		"project"
	targetdir		"bin"

	flags "StaticRuntime"

	defines 	{ }
	configurations { "IA32" }

	configuration "IA32"
		platforms "x32"
		buildoptions {"-m32"}
		optimize 	"On"
		--defines ""
		
	project "swiftos.bootloader.stage1"
		kind				"StaticLib"
		language			"C++"
		targetdir		"bootloader/stage1/bin"
		targetextension		".bin2"
		compilebuildoutputs "Off"
		linkbuildoutputs "Off"
		files 	{ "bootloader/stage1/src/*.asm" }
		filter {'files:bootloader/stage1/src/*.asm'}
			buildmessage 'Compiling %{file.relpath}'
			buildoutputs { 'bootloader/stage1/bin/%{file.basename}.bin' }
			buildcommands {
				'nasm.exe -f bin "%{file.relpath}" -o "../bootloader/stage1/bin/%{file.basename}.bin"'
			}
		filter {}
		
	project "swiftos.bootloader.stage2"
		kind				"StaticLib"
		language			"C++"
		targetdir		"bootloader/stage2/bin"
		targetextension		".bin2"
		files 	{ "bootloader/stage2/src/*.asm", "bootloader/stage2/src/**.cpp","bootloader/stage2/src/**.c"}
		filter {'files:bootloader/stage2/src/*.asm'}
			buildmessage 'Compiling %{file.relpath}'
			buildoutputs { 'bootloader/stage2/bin/%{file.basename}.bin' }
			buildcommands {
				'nasm.exe -f bin "%{file.relpath}" -o "../bootloader/stage2/bin/%{file.basename}.bin"'
			}
		filter {}
		buildoptions{ "-ffreestanding" }
	--[[
	project "swiftos.bootloader"
		kind				"StaticLib"
		language			"C"
		targetextension		".bin"
		filter {'files:bootloader/stage1/src/*.asm', 'platforms:x32'}
			buildmessage 'Compiling %{file.relpath}'
			buildoutputs { 'bootloader/stage1/obj/%{file.basename}.obj' }
			buildcommands {
				'..\\bin\\nasm.exe -f bin -o "bootloader/stage1/bin/%{file.basename}.bin" "%{file.relpath}"'
			}
		filter {}
	]]
	--[[
	project "swiftos.bootloader.stage2"
		targetextension		".bin"
		kind	"StaticLib"
		includedirs{ "bootloader/stage2/include/" }
		files { "bootloader/stage2/src/*.asm", "bootloader/stage2/src/**.cpp", "bootloader/stage2/src/**.c" }
		--links { }
		--linkoptions { }
		
		filter {'files:bootloader/stage2/src/*.asm', 'platforms:x32'}
			buildmessage 'Compiling %{file.relpath}'
			buildoutputs { 'bootloader/stage2/obj/%{file.basename}.obj' }
			buildcommands {
				'..\\bin\\nasm.exe -f bin -o "%bootloader/stage2/obj/%{file.basename}.obj" "%{file.relpath}"'
			}
		filter {}

	project "swiftos.bootloader"
		targetextension		".bin"
		kind	"StaticLib"
		includedirs{ 
			"../source-sdk-2013/mp/src/lib/public",
			"../source-sdk-2013/mp/src/lib/common",
			"../source-sdk-2013/mp/src/public",
			"../source-sdk-2013/mp/src/public/Tier0",
			"../source-sdk-2013/mp/src/public/Tier1",
			"../source-sdk-2013/mp/src/common",
			"../garrysmod_common/include",
			"../garrysmod_common/include/garrysmod/lua",
			"./"}
			
		files 	{ "navigation/sources/**.cpp","navigation/sources/**.c"}
		links{
		"../source-sdk-2013/mp/src/lib/public/mathlib",
		"../source-sdk-2013/mp/src/lib/public/tier0",
		"../source-sdk-2013/mp/src/lib/public/tier1",
		"../source-sdk-2013/mp/src/lib/public/vstdlib",
		"../source-sdk-2013/mp/src/lib/common/lzma"}
		linkoptions { '/NODEFAULTLIB:MSVCRT.lib' }
		
	project "swiftos.kernel"
		targetextension		".bin"
		kind	"StaticLib"
		includedirs{ "kernel/include" }
		files 	{ "kernel/src/**.cpp","kernel/src/**.c"}
		links{ }
		linkoptions { '/NODEFAULTLIB:MSVCRT.lib' }
		
	]]